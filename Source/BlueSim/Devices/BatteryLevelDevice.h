// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "SimulatedDevice.h"

@interface BatteryLevelDevice : SimulatedDevice

@property (nonatomic) int batteryLevel; // Percentage of battery charge remaining
@property (nonatomic) BOOL charging;    // YES if the battery is connected to external power

@end