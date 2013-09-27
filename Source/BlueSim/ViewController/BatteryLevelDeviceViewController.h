// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import <UIKit/UIKit.h>

@interface BatteryLevelDeviceViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *powerSwitch;
@property (weak, nonatomic) IBOutlet UILabel *batteryLevelHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLevelLabel;
@property (weak, nonatomic) IBOutlet UISlider *batteryLevelSlider;
@property (weak, nonatomic) IBOutlet UILabel *chargingLabel;
@property (weak, nonatomic) IBOutlet UISwitch *chargingSwitch;

@end