// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "BatteryLevelDevice.h"
#import <CoreBluetooth/CoreBluetooth.h>

// Simulates a custom device with:
//
//      * Battery charge remaining percentage
//      * Boolean indicating if the device is charging

#define BATTERY_LEVEL_SERVICE_UUID          @"3e31444a-a5ca-47f9-af2b-4b4f88eaefd9" // Generate your own UUID for your service
#define BATTERY_LEVEL_CHARACTERISTIC_UUID   @"b252c7e3-52b4-43dd-8487-dca36e56a7dc" // Generate your own UUID for your characteristic

@interface BatteryLevelDevice()

@property (nonatomic, strong) CBMutableService *batteryService;
@property (nonatomic, strong) CBMutableCharacteristic *batteryLevelCharateristic;

@end

@implementation BatteryLevelDevice
{
    NSArray *_services;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _batteryLevel = 90;
        _charging = NO;
    }
    return self;
}

- (NSString *)name
{
    return @"Battery Level";
}

- (NSString *)imageName
{
    return @"BatteryLevel.png";
}

- (NSArray *)services
{
    if (!_services) _services = @[[self createBatteryService]];
    return _services;
}

- (void)setBatteryLevel:(int)batteryLevel
{
    if (_batteryLevel == batteryLevel)
        return;
    _batteryLevel = batteryLevel;
    [self sendBatteryLevelUpdate];
}

- (void)setCharging:(BOOL)charging
{
    if (_charging == charging)
        return;
    _charging = charging;
    [self sendBatteryLevelUpdate];
}

- (CBMutableService *)createBatteryService
{
    self.batteryLevelCharateristic =
        [[CBMutableCharacteristic alloc]
            initWithType:[CBUUID UUIDWithString:BATTERY_LEVEL_CHARACTERISTIC_UUID]
              properties:(CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify)
                   value:nil
             permissions:CBAttributePermissionsReadable];
    

    self.batteryService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:BATTERY_LEVEL_SERVICE_UUID] primary:YES];
    self.batteryService.characteristics = @[self.batteryLevelCharateristic];
    return self.batteryService;
}

- (NSData *)getCharacteristicValue:(CBCharacteristic *) characteristic
{
    if ([characteristic.UUID isEqual:self.batteryLevelCharateristic.UUID])
    {
        NSLog(@"Reading battery level");
        return [self makeBatteryLevelPayload];
    }
    return nil;
}

- (void)sendBatteryLevelUpdate
{
    NSLog(@"Sending battery level update");
    
    [self.manager updateValue:[self makeBatteryLevelPayload]
            forCharacteristic:self.batteryLevelCharateristic
         onSubscribedCentrals:nil];
}

- (NSData *)makeBatteryLevelPayload
{
    NSMutableData *payload = [NSMutableData dataWithLength:2];
    uint8_t *bytes = [payload mutableBytes];
    bytes[0] = (uint8_t)self.batteryLevel;
    bytes[1] = self.charging;
    return payload;
}

@end
