// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "SimulatedDevice.h"

typedef NS_ENUM(uint8_t, TemperatureType) {
    TemperatureTypeArmpit   = 1,
    TemperatureTypeBody     = 2,
    TemperatureTypeEar      = 3,
    TemperatureTypeFinger   = 4,
    TemperatureTypeGastro   = 5,
    TemperatureTypeMouth    = 6,
    TemperatureTypeRectum   = 7,
    TemperatureTypeToe      = 8,
    TemperatureTypeTympanum = 9,
};

typedef NS_ENUM(uint8_t, TemperatureUnits) {
    Celsius      = 0,
    Fahrenheit   = 1,
};

@interface HealthThermometerDevice : SimulatedDevice

@property (nonatomic) float temperature;
@property (nonatomic) TemperatureUnits units;
@property (nonatomic) TemperatureType type;

@end