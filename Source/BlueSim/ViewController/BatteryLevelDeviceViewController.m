// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "BatteryLevelDeviceViewController.h"
#import "BLEDeviceSimulator.h"
#import "BatteryLevelDevice.h"

@interface BatteryLevelDeviceViewController ()

@property (nonatomic, strong) BatteryLevelDevice *batteryLevelDevice;

@end

@implementation BatteryLevelDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    BLEDeviceSimulator *simulator = [BLEDeviceSimulator instance];
    self.batteryLevelDevice = [simulator getDeviceByName:@"Battery Level"];
    self.powerSwitch.on = self.batteryLevelDevice.on;
    self.batteryLevelSlider.value = self.batteryLevelDevice.batteryLevel;

    [self updateUI];
}

- (void)updateUI
{
    self.batteryLevelHeaderLabel.enabled = self.batteryLevelLabel.enabled =
        self.batteryLevelSlider.enabled = self.chargingLabel.enabled =
        self.chargingSwitch.enabled = self.batteryLevelDevice.on;
    
    self.batteryLevelLabel.text = [NSString stringWithFormat:@"%d%%", self.batteryLevelDevice.batteryLevel];
    
    self.chargingSwitch.on = self.batteryLevelDevice.charging;
}

- (IBAction)powerSwitchChanged:(id)sender
{
    self.batteryLevelDevice.on = self.powerSwitch.on;
    [self updateUI];
}

- (IBAction)batteryLevelValueChanged:(id)sender
{
    self.batteryLevelDevice.batteryLevel = (int)self.batteryLevelSlider.value;
    [self updateUI];
}

- (IBAction)chargingSwitchChanged:(id)sender
{
    self.batteryLevelDevice.charging = self.chargingSwitch.on;
}

@end