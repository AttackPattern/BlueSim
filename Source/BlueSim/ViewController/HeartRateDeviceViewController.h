// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import <UIKit/UIKit.h>

@interface HeartRateDeviceViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *heartRateHeaderLabel;
@property (weak, nonatomic) IBOutlet UISwitch *powerSwitch;
@property (weak, nonatomic) IBOutlet UILabel *heartRateIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UISlider *heartRateSlider;
@property (weak, nonatomic) IBOutlet UILabel *sensorLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sensorLocationValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxValueLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *sensorLocationCell;

@end