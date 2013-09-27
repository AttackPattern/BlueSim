// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

// Simulates a blood pressure device with:
//
//      * Systolic blood pressure (required)
//      * Diastolic blood pressure (required)
//      * Mean arterial blood pressure (required)
//      * Pulse rate BPM (optional)
//
// http://developer.bluetooth.org/gatt/services/Pages/ServiceViewer.aspx?u=org.bluetooth.service.blood_pressure.xml

#import "BloodPressureDevice.h"
#import <Foundation/NSNotification.h>
#import <Foundation/Foundation.h>

#define BLOOD_PRESSURE_SERVICE_UUID                      @"1810"
#define BLOOD_PRESSURE_MEASUREMENT_CHARACTERISTIC_UUID   @"2A35"
#define BLOOD_PRESSURE_FEATURE_CHARACTERISTIC_UUID       @"2A49"

@interface BloodPressureDevice()

@property (nonatomic, strong) CBMutableService *bloodPressureService;
@property (nonatomic, strong) CBMutableCharacteristic *bloodPressureMeasurementCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *bloodPressureFeatureCharacteristic;

@end

enum BloodPressureFlags
{
    UnitskPa = 0x1,
    TimeStampPresent = 0x2,
    PulseRatePresent = 0x4,
    UserIdPresent = 0x8,
    MeasurementStatusPresent = 0x10
};

@implementation BloodPressureDevice
{
    NSArray *_services;
}

- (NSString *)name
{
    return @"Blood Pressure";
}

- (NSString *)imageName
{
    return @"BloodPressure.png";
}

- (NSArray *)services
{
    if (!_services) _services = @[[self createBloodPressureService]];
    return _services;
}

- (void)setArterialBloodPressure:(float)arterialBloodPressure
{
    _arterialBloodPressure = arterialBloodPressure;
    [self sendBloodPressureMeasurement];
}

- (void)setSystolicBloodPressure:(float)systolicBloodPressure
{
    _systolicBloodPressure = systolicBloodPressure;
    [self sendBloodPressureMeasurement];
}

- (void)setDiastolicBloodPressure:(float)diastolicBloodPressure
{
    _diastolicBloodPressure = diastolicBloodPressure;
    [self sendBloodPressureMeasurement];
}

- (void)setPulseRateBeatsPerMinute:(int)pulseRateBeatsPerMinute
{
    _pulseRateBeatsPerMinute = pulseRateBeatsPerMinute;
    [self sendBloodPressureMeasurement];
}

- (CBMutableService *)createBloodPressureService
{
    self.bloodPressureService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:BLOOD_PRESSURE_SERVICE_UUID]
                                                           primary:YES];
    
    self.bloodPressureMeasurementCharacteristic = [[CBMutableCharacteristic alloc]
                                               initWithType:[CBUUID UUIDWithString:BLOOD_PRESSURE_MEASUREMENT_CHARACTERISTIC_UUID]
                                               properties:CBCharacteristicPropertyIndicate
                                               value:nil
                                               permissions:CBAttributePermissionsReadable];
        
    self.bloodPressureFeatureCharacteristic = [[CBMutableCharacteristic alloc]
                                                   initWithType:[CBUUID UUIDWithString:BLOOD_PRESSURE_FEATURE_CHARACTERISTIC_UUID]
                                                   properties:(CBCharacteristicPropertyRead)
                                                   value:nil
                                                   permissions:CBAttributePermissionsReadable];
    
    self.bloodPressureService.characteristics = @[self.bloodPressureMeasurementCharacteristic, self.bloodPressureFeatureCharacteristic];
    
    return self.bloodPressureService;
}

- (NSData *)getCharacteristicValue:(CBCharacteristic *) characteristic
{
    if ([characteristic.UUID isEqual:self.bloodPressureFeatureCharacteristic.UUID])
    {
        NSLog(@"Reading blood pressure feature");
        return [self makeBloodPressureFeaturePayload];
    }
    return nil;
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    if ([characteristic.UUID isEqual:self.bloodPressureMeasurementCharacteristic.UUID])
    {
        NSLog(@"Subscribed to blood pressure measurement characteristic");
        [self sendBloodPressureMeasurement];
    }
}

const double kPa_mmHg = 7.50061683;
const double mmHg_kPa = 0.133322368;

- (void)setPressureUnits:(PressureUnits)pressureUnits
{
    if (pressureUnits == _pressureUnits) return;
    _pressureUnits = pressureUnits;

    double conversion = pressureUnits == kPa ? mmHg_kPa : kPa_mmHg;

    _systolicBloodPressure = (int) (self.systolicBloodPressure * conversion);
    _diastolicBloodPressure = (int) (self.diastolicBloodPressure * conversion);
    _arterialBloodPressure = (int) (self.arterialBloodPressure * conversion);
    [self sendBloodPressureMeasurement];
}

- (void)sendBloodPressureMeasurement
{
    NSLog(@"Sending blood pressure measurement");

    [self.manager updateValue:[self makeBloodPressureMeasurementPayload]
            forCharacteristic:self.bloodPressureMeasurementCharacteristic
         onSubscribedCentrals:nil];
}

#define MANTISSA_MAX_VALUE 2047
#define MANTISSA_MIN_VALUE -2048

- (uint16_t) makeBluetoothShortFloat:(float)value
{
    // Bluetooth short floats are 16 bits:
    // Bits 15-12 are base 10 exponent, signed in 2's complement (-8 to +7)
    // Bits 11-0  are mantissa, signed in 2's complement (-2048 to +2047)
    bool isNegative = value < 0.0;
    if (isNegative) value = -value;

    float mantissa = value;
    int exponent = 0;
    
    if (0 < mantissa && mantissa <= MANTISSA_MAX_VALUE)
        for(; mantissa * 10 < MANTISSA_MAX_VALUE; exponent--)
            mantissa *= 10.0;
    else if (mantissa > MANTISSA_MAX_VALUE)
        for(; mantissa > MANTISSA_MAX_VALUE; exponent++)
            mantissa /= 10.0;
	else if (0 > mantissa && mantissa >= MANTISSA_MIN_VALUE)
        for(;  mantissa * 10 > MANTISSA_MIN_VALUE; exponent--)
            mantissa *= 10.0;
	else if (mantissa < MANTISSA_MIN_VALUE)
        for(;  mantissa < MANTISSA_MIN_VALUE; exponent++)
            mantissa /= 10.0;
    
    // NOTE: We should do a range check on exponent make sure it is less than 7 and greater than -8
    // but we know we won't need to in this case.
    
    uint16_t result = trunc(mantissa);
    result &= 0x0FFF; // Clear out the top bits so we can or in the exponent
    result |= (exponent << 12);
    return result;
}

- (NSData *)makeBloodPressureMeasurementPayload
{
    // The structure of the blood pressure measurement characteristic is described at
    // http://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.blood_pressure_measurement.xml

    NSUInteger length = 7 + (self.includePulseRate ? 2 : 0);
    NSMutableData* payload = [NSMutableData dataWithLength:length];
    uint8_t *bytes = [payload mutableBytes];

    if (self.pressureUnits == kPa)
        bytes[0] |= UnitskPa;

    uint16_t systolic = [self makeBluetoothShortFloat:self.systolicBloodPressure];
    bytes[1] = systolic & 0x000000FF;
    bytes[2] = (systolic & 0x0000FF00) >> 8;

    uint16_t diastolic = [self makeBluetoothShortFloat:self.diastolicBloodPressure];
    bytes[3] = diastolic & 0x000000FF;
    bytes[4] = (diastolic & 0x0000FF00) >> 8;

    uint16_t arterial = [self makeBluetoothShortFloat:self.arterialBloodPressure];
    bytes[5] = arterial & 0x000000FF;
    bytes[6] = (arterial & 0x0000FF00) >> 8;
    
    if (self.includePulseRate)
    {
        bytes[0] |= PulseRatePresent;
        uint16_t pulse = [self makeBluetoothShortFloat:(float)self.pulseRateBeatsPerMinute];
        bytes[7] = pulse & 0x000000FF;
        bytes[8] = (pulse & 0x0000FF00) >> 8;
    }
    
    return payload;
}

- (NSData *)makeBloodPressureFeaturePayload
{
    // The structure of the blood pressure feature characteristic is described at
    // https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.blood_pressure_feature.xml
    
    NSMutableData* payload = [NSMutableData dataWithLength:2];
    uint16_t *bytes = [payload mutableBytes];
    bytes[0] = 0;
    bytes[1] = 0;
    return payload;
}

@end
