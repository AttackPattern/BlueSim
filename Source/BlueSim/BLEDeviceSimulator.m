// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "BLEDeviceSimulator.h"
#import "TimeDevice.h"
#import "HeartRateDevice.h"
#import "BloodPressureDevice.h"
#import "HealthThermometerDevice.h"
#import "BatteryLevelDevice.h"

@implementation BLEDeviceSimulator

static BLEDeviceSimulator *_instance;

+ (BLEDeviceSimulator *)instance
{
    if (!_instance) _instance = [[BLEDeviceSimulator alloc] init];
    return _instance;
}

// List of all devices supported used to build home screen.
- (NSMutableArray *)devices
{
    if (!_devices)
    {
        _devices = [[NSMutableArray alloc] init];
        [_devices addObject:[[TimeDevice alloc] init]];
        [_devices addObject:[[HeartRateDevice alloc] init]];
        [_devices addObject:[[BloodPressureDevice alloc] init]];
        [_devices addObject:[[HealthThermometerDevice alloc] init]];
        [_devices addObject:[[BatteryLevelDevice alloc] init]];
        // Add your devices here.
    }
    return _devices;
}

// Obtain a SimulatedDevice by it's name property.
- (id)getDeviceByName:(NSString *) name
{
    for (SimulatedDevice *device in self.devices) {
        if ([device.name isEqualToString:name])
             return device;
    }
    return nil;
}

@end