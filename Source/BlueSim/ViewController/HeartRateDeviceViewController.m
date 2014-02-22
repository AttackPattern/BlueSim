// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "HeartRateDeviceViewController.h"
#import "BLEDeviceSimulator.h"
#import "HeartRateDevice.h"
#import "HeartRateLocationViewController.h"

@interface HeartRateDeviceViewController ()

@property (strong, nonatomic) HeartRateDevice *heartRateDevice;
@property (strong, nonatomic) NSArray *sensorLocations;

@end

@implementation HeartRateDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    BLEDeviceSimulator *simulator = [BLEDeviceSimulator instance];
    self.heartRateDevice = [simulator getDeviceByName:@"Heart Rate"];
    self.powerSwitch.on = self.heartRateDevice.on;
    self.heartRateLabel.text = [NSString stringWithFormat:@"%d", self.heartRateDevice.heartRate];
    self.heartRateSlider.value = self.heartRateDevice.targetHeartRate;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(heartRateChanged)
                                                 name:@"BTHeartRateChanged"
                                               object:nil];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self updateUI];
}

- (NSArray *)sensorLocations
{
    if (!_sensorLocations) _sensorLocations = @[@"Other", @"Chest", @"Wrist", @"Finger", @"Hand", @"Ear Lobe", @"Foot"];
    return _sensorLocations;
}

- (IBAction)heartRateSliderChanged:(UISlider *)sender;
{
    self.heartRateDevice.targetHeartRate = (int)sender.value;
}

- (void)heartRateChanged
{
    self.heartRateLabel.text = [NSString stringWithFormat:@"%d", self.heartRateDevice.heartRate];
}
- (IBAction)powerSwitchChanged:(id)sender
{
    if (self.heartRateDevice.on != self.powerSwitch.on)
    {
        self.heartRateDevice.on = self.powerSwitch.on;
        [self updateUI];
    }
}

- (void)updateUI
{
    self.heartRateHeaderLabel.enabled =
        self.heartRateLabel.enabled = self.heartRateSlider.enabled =
        self.minValueLabel.enabled = self.maxValueLabel.enabled =
        self.sensorLocationCell.userInteractionEnabled = self.sensorLocationLabel.enabled =
        self.heartRateIconLabel.enabled = 
        self.sensorLocationValueLabel.enabled = self.heartRateDevice.on;
    
    self.sensorLocationValueLabel.text = self.sensorLocations[self.heartRateDevice.location];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SensorLocation"])
    {
        HeartRateLocationViewController *locationViewController = segue.destinationViewController;
        locationViewController.heartRateDevice = self.heartRateDevice;
        locationViewController.sensorLocations = self.sensorLocations;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end