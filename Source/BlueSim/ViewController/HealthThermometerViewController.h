// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import <UIKit/UIKit.h>

@interface HealthThermometerViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *powerSwitch;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UISlider *temperatureSlider;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitsSelector;
@property (weak, nonatomic) IBOutlet UILabel *temperatureTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureTypeValueLabel;

@end