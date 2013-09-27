// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "HealthThermometerDevice.h"

// Simulates a health thermometer device with:
//
//      * Temperature (required)
//      * Sensor body location (required)
//
// http://developer.bluetooth.org/gatt/services/Pages/ServiceViewer.aspx?u=org.bluetooth.service.heart_rate.xml

#define HEALTH_THERMOMETER_SERVICE_UUID                 @"1809"
#define TEMPERATURE_MEASUREMENT_CHARACTERISTIC_UUID     @"2A1C"
#define TEMPERATURE_TYPE_CHARACTERISTIC_UUID            @"2A1D"

@interface HealthThermometerDevice()

@property (nonatomic, strong) CBMutableService *thermometerService;
@property (nonatomic, strong) CBMutableCharacteristic *temperatureCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *typeCharacteristic;

@end

enum ThermometerFlags
{
    TimeStampPresent = 0x2,
    TemperatureTypePresent = 0x4
};

@implementation HealthThermometerDevice
{
    NSArray *_services;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _temperature = 98.6;
        _type = TemperatureTypeBody;
        _units = Fahrenheit;
    }
    return self;
}

- (NSString *)name
{
    return @"Health Thermometer";
}

- (NSString *)imageName
{
    return @"HealthThermometer.png";
}

- (void)setTemperature:(float)temperature
{
    _temperature = temperature;
    [self sendTemperatureUpdate];
}

- (void)setUnits:(TemperatureUnits)units
{
    if (_units == units)
        return;
    
    _units = units;
    
    // Convert the temperature to it's new units
    if (_units == Fahrenheit)
        self.temperature = ((9.0/5.0) * self.temperature) + 32.0;
    else
        self.temperature = (5.0/9.0) * (self.temperature - 32.0);
}

- (void)setType:(TemperatureType)type
{
    if (_type == type)
        return;
    _type = type;
    [self sendTemperatureUpdate];
}

- (NSArray *)services
{
    if (!_services) _services = @[[self createThermometerService]];
    return _services;
}

- (CBMutableService *)createThermometerService
{
    self.thermometerService =
        [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:HEALTH_THERMOMETER_SERVICE_UUID]
                                       primary:YES];

    self.temperatureCharacteristic =
        [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TEMPERATURE_MEASUREMENT_CHARACTERISTIC_UUID]
                                           properties:CBCharacteristicPropertyIndicate
                                                value:nil
                                          permissions:CBAttributePermissionsReadable];

    self.typeCharacteristic =
        [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TEMPERATURE_TYPE_CHARACTERISTIC_UUID]
                                           properties:CBCharacteristicPropertyRead
                                                value:nil
                                          permissions:CBAttributePermissionsReadable];

    self.thermometerService.characteristics = @[self.temperatureCharacteristic, self.typeCharacteristic];
    return self.thermometerService;
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    if ([characteristic.UUID isEqual:self.temperatureCharacteristic.UUID])
    {
        NSLog(@"Subscribed to temperature characteristic");
        [self sendTemperatureUpdate];
    }
}

- (NSData *)getCharacteristicValue:(CBCharacteristic *) characteristic
{
    if ([characteristic.UUID isEqual:self.typeCharacteristic.UUID])
    {
        NSLog(@"Reading temperature type");
        return [self makeTemperatureTypePayload];
    }
    return nil;
}

- (void)sendTemperatureUpdate
{
    NSLog(@"Sending temperature update");

    [self.manager updateValue:[self makeTemperaturePayload]
            forCharacteristic:self.temperatureCharacteristic
         onSubscribedCentrals:nil];
}

- (NSData *)makeTemperatureTypePayload
{
    // The structure of the temperature type characteristic is described at    
    // https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.temperature_type.xml
    
    NSMutableData* payload = [NSMutableData dataWithLength:1];
    uint8_t *bytes = [payload mutableBytes];
    bytes[0] = self.type;
    return payload;
}

- (NSData *)makeTemperaturePayload
{
    // The structure of the temperature measurement characteristic is described at
    // https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.temperature_measurement.xml
    
    NSMutableData* payload = [NSMutableData dataWithLength:13];
    uint8_t *bytes = [payload mutableBytes];
    
    bytes[0] = self.units; // 0x00 = First bit indicates temperature measurement (0 = Celsius, 1 = Fahrenheit)
    bytes[0] |= TimeStampPresent | TemperatureTypePresent;
    
    uint32_t temperatureFloat = [self makeBluetoothFloat:self.temperature precision:3];
    bytes[1] = temperatureFloat & 0x000000FF;
    bytes[2] = (temperatureFloat & 0x0000FF00) >> 8;
    bytes[3] = (temperatureFloat & 0x00FF0000) >> 16;
    bytes[4] = (temperatureFloat & 0xFF000000) >> 24;
    [self setDateTime:&bytes[5]];
    bytes[12] = self.type;
    return payload;
}


- (void)setDateTime:(uint8_t *)bytes
{
    // Get the current time
    NSDate *currentTime = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *time = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                                                    NSWeekdayCalendarUnit | NSDayCalendarUnit |
                                                    NSHourCalendarUnit | NSMinuteCalendarUnit |
                                                    NSSecondCalendarUnit)
                                          fromDate:currentTime];
    
    UInt16 year = time.year;
    
    // Format the time according to the Bluetooth spec
    // [year][year][month][day][hours][minutes][seconds][day of week][1/256th of a second],[Adjust Reason]
    // http://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.current_time.xml
    //
    // Note: All multi-byte data types in BLE are little-endian (see the Core Bluetooth Spec v4)
    // iOS/ARM is also little endian so we can simply copy bytes directly into the message body
    bytes[0] = ((uint8_t *)&year)[0];
    bytes[1] = ((uint8_t *)&year)[1];
    bytes[2] = (uint8_t) time.month;
    bytes[3] = (uint8_t) time.day;
    bytes[4] = (uint8_t) time.hour;
    bytes[5] = (uint8_t) time.minute;
    bytes[6] = (uint8_t) time.second;    
}

- (uint32_t)makeBluetoothFloat:(float)value precision:(uint8_t)precision
{
    // Bluetooth FLOAT-TYPE is defined in ISO/IEEE Std. 11073
    // FLOATs are 32 bit
    // Format [8bit exponent][24bit mantissa]
    int8_t exponent = -precision;
    uint32_t mantissa = trunc(value * pow(10.0, precision));
    
    // If we wanted this to be completely robust we would need to range
    // check mantissa (ex mantissa < 24BIT_SIGNED_INTEGER_MAX_VALUE)
    // and exponent
    return exponent << 24 | ((0x00FFFFFF) & mantissa);
}

@end
