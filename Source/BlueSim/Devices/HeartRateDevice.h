// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "SimulatedDevice.h"

extern NSString *heartRateChanged;

typedef NS_ENUM(uint8_t, HeartRateSensorLocation) {
    HRSensorLocationOther   = 0,
    HRSensorLocationChest   = 1,
    HRSensorLocationWrist   = 2,
    HRSensorLocationFinger  = 3,
    HRSensorLocationHand    = 4,
    HRSensorLocationEarLobe = 5,
    HRSensorLocationFoot    = 6,
};

@interface HeartRateDevice : SimulatedDevice

@property (nonatomic) uint8_t targetHeartRate;
@property (readonly, nonatomic) uint8_t heartRate;
@property (nonatomic) HeartRateSensorLocation location;

@end