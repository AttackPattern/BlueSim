// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "SimulatedDevice.h"

extern NSString *bloodPressureChanged;

typedef enum { mmHg, kPa } PressureUnits;

@interface BloodPressureDevice : SimulatedDevice

@property (nonatomic) PressureUnits pressureUnits;
@property (nonatomic) float systolicBloodPressure;
@property (nonatomic) float diastolicBloodPressure;
@property (nonatomic) float arterialBloodPressure;

@property (nonatomic) BOOL includePulseRate;
@property (nonatomic) int pulseRateBeatsPerMinute;

@end