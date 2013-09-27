// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "BloodPressureDeviceViewController.h"
#import "BLEDeviceSimulator.h"
#import "BloodPressureDevice.h"

@interface BloodPressureDeviceViewController ()

@property (strong, nonatomic) BloodPressureDevice *bloodPressureDevice;

@end

@implementation BloodPressureDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BLEDeviceSimulator *simulator = [BLEDeviceSimulator instance];
    self.bloodPressureDevice = [simulator getDeviceByName:@"Blood Pressure"];
    self.powerSwitch.on = self.bloodPressureDevice.on;
    
    [self updateUI];
}

- (IBAction)powerSwitchChanged:(id)sender
{
    if (self.bloodPressureDevice.on != self.powerSwitch.on)
    {
        self.bloodPressureDevice.on = self.powerSwitch.on;
        [self updateUI];
    }
}

- (void)updateUI
{
    BloodPressureDevice *device = self.bloodPressureDevice;
    
    self.unitsLabel.enabled = self.unitsSegmentedControl.enabled =
        self.systolicRowLabel.enabled = self.systolicLabel.enabled =
        self.systolicSlider.enabled = self.diastolicRowLabel.enabled =
        self.diastolicLabel.enabled = self.diastolicSlider.enabled =
        self.arterialRowLabel.enabled = self.arterialLabel.enabled =
        self.arterialSlider.enabled = self.pulseRowLabel.enabled =
        self.pulseRateLabel.enabled = self.pulseRateSlider.enabled = device.on;
    
    self.unitsSegmentedControl.selectedSegmentIndex = device.pressureUnits == mmHg ? 0 : 1;
    NSString *format = device.pressureUnits == mmHg ? @"%.0f" : @"%.1f";
    
    self.systolicLabel.text = [NSString stringWithFormat:format, device.systolicBloodPressure];
    self.diastolicLabel.text = [NSString stringWithFormat:format, device.diastolicBloodPressure];
    self.arterialLabel.text = [NSString stringWithFormat:format, device.arterialBloodPressure];
    
    float ratio = [self getSliderRatio];
    self.systolicSlider.value = device.systolicBloodPressure * ratio;
    self.diastolicSlider.value = device.diastolicBloodPressure * ratio;
    self.arterialSlider.value = device.arterialBloodPressure * ratio;

    self.pulseRateSlider.value = !device.includePulseRate ? 0 : device.pulseRateBeatsPerMinute;
    self.pulseRateLabel.text = !device.includePulseRate ? @"OFF"
        : [NSString stringWithFormat:@"%d", device.pulseRateBeatsPerMinute];
}

- (float)getSliderRatio
{
    return self.bloodPressureDevice.pressureUnits == mmHg ? 1 : 7.50061683;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)unitsChanged:(UISegmentedControl *)sender {
    self.bloodPressureDevice.pressureUnits =
        sender.selectedSegmentIndex == 0 ? mmHg : 1;
    [self updateUI];
}

- (IBAction)systolicChange:(UISlider *)sender {
    self.bloodPressureDevice.systolicBloodPressure = sender.value / [self getSliderRatio];
    [self updateUI];
}

- (IBAction)diastolicChanged:(UISlider *)sender {
    self.bloodPressureDevice.diastolicBloodPressure = sender.value / [self getSliderRatio];
    [self updateUI];
}

- (IBAction)arterialChanged:(UISlider *)sender {
    self.bloodPressureDevice.arterialBloodPressure = sender.value / [self getSliderRatio];
    [self updateUI];
}

- (IBAction)pulseRateChanged:(UISlider *)sender {
    self.bloodPressureDevice.pulseRateBeatsPerMinute = sender.value;
    self.bloodPressureDevice.includePulseRate = sender.value > 0;
    [self updateUI];
}

@end