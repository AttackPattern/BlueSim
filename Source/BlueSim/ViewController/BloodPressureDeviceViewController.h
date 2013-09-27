// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import <UIKit/UIKit.h>

@interface BloodPressureDeviceViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *powerSwitch;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitsSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *systolicLabel;
@property (weak, nonatomic) IBOutlet UILabel *systolicRowLabel;
@property (weak, nonatomic) IBOutlet UISlider *systolicSlider;
@property (weak, nonatomic) IBOutlet UILabel *diastolicLabel;
@property (weak, nonatomic) IBOutlet UILabel *diastolicRowLabel;
@property (weak, nonatomic) IBOutlet UISlider *diastolicSlider;
@property (weak, nonatomic) IBOutlet UILabel *arterialLabel;
@property (weak, nonatomic) IBOutlet UILabel *arterialRowLabel;
@property (weak, nonatomic) IBOutlet UISlider *arterialSlider;
@property (weak, nonatomic) IBOutlet UILabel *pulseRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pulseRowLabel;
@property (weak, nonatomic) IBOutlet UISlider *pulseRateSlider;

- (IBAction)powerSwitchChanged:(UISwitch *)sender;
- (IBAction)unitsChanged:(UISegmentedControl *)sender;
- (IBAction)systolicChange:(UISlider *)sender;
- (IBAction)diastolicChanged:(UISlider *)sender;
- (IBAction)arterialChanged:(UISlider *)sender;
- (IBAction)pulseRateChanged:(UISlider *)sender;

@end