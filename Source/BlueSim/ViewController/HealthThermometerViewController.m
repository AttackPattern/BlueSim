// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "HealthThermometerViewController.h"
#import "BLEDeviceSimulator.h"
#import "HealthThermometerDevice.h"
#import "OptionSelectorViewController.h"

@interface HealthThermometerViewController () <OptionSelectorDelegate>

@property (nonatomic) BOOL useFahrenheit;
@property (nonatomic, strong) HealthThermometerDevice *healthThermometerDevice;
@property (nonatomic, readonly) NSArray *temperatureTypeOptions;

@end

@implementation HealthThermometerViewController
{
    NSArray *_temperatureTypeOptions;
}

- (NSArray *)temperatureTypeOptions
{
    if (!_temperatureTypeOptions)
    {
        _temperatureTypeOptions =
            @[
              [Option createWithName:@"Armpit"  intValue:TemperatureTypeArmpit],
              [Option createWithName:@"Body"    intValue:TemperatureTypeBody],
              [Option createWithName:@"Ear"     intValue:TemperatureTypeEar],
              [Option createWithName:@"Finger"  intValue:TemperatureTypeFinger],
              [Option createWithName:@"Gastro"  intValue:TemperatureTypeGastro],
              [Option createWithName:@"Mouth"   intValue:TemperatureTypeMouth],
              [Option createWithName:@"Rectum"  intValue:TemperatureTypeRectum],
              [Option createWithName:@"Toe"   intValue:TemperatureTypeToe],
              [Option createWithName:@"Tympanum (Ear Drum)"   intValue:TemperatureTypeTympanum],
            ];
    }
    return _temperatureTypeOptions;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    BLEDeviceSimulator *simulator = [BLEDeviceSimulator instance];
    self.healthThermometerDevice = [simulator getDeviceByName:@"Health Thermometer"];
    self.powerSwitch.on = self.healthThermometerDevice.on;
    self.useFahrenheit = self.healthThermometerDevice.units == Fahrenheit;
    self.unitsSelector.selectedSegmentIndex = self.useFahrenheit ? 0 : 1;
    [self onUnitsChanged:nil];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self updateUI];
}

- (void)updateUI
{
    self.currentTemperatureHeadingLabel.enabled = self.currentTemperatureLabel.enabled =
        self.minLabel.enabled = self.maxLabel.enabled =
        self.temperatureSlider.enabled = self.unitsLabel.enabled =
        self.unitsSelector.enabled = self.temperatureTypeLabel.enabled =
        self.temperatureTypeValueLabel.enabled = self.healthThermometerDevice.on;
    
    [self.tableView setAllowsSelection:self.healthThermometerDevice.on];
    
    self.currentTemperatureLabel.text = [NSString stringWithFormat:(self.useFahrenheit ?@"%.1fº F" : @"%.1fº C"), self.healthThermometerDevice.temperature];
    
    self.temperatureSlider.value = self.healthThermometerDevice.temperature;
    
    Option *temperatureType = [self getCurrentTemperatureTypeOption];
    self.temperatureTypeValueLabel.text = temperatureType.name;
}

- (IBAction)powerSwitchChanged:(id)sender
{
    if (self.healthThermometerDevice.on != self.powerSwitch.on)
    {
        self.healthThermometerDevice.on = self.powerSwitch.on;
        [self updateUI];
    }
}

- (IBAction)temperatureSliderChanged:(id)sender
{
    self.healthThermometerDevice.temperature = self.temperatureSlider.value;
    self.currentTemperatureLabel.text = [NSString stringWithFormat:(self.useFahrenheit ?@"%.1fº F" : @"%.1fº C"), self.healthThermometerDevice.temperature];
}

- (IBAction)onUnitsChanged:(id)sender
{
    self.useFahrenheit = self.unitsSelector.selectedSegmentIndex == 0;

    if (self.useFahrenheit)
    {
        self.minLabel.text = @"90";
        self.maxLabel.text = @"120";
        self.temperatureSlider.minimumValue = 90;
        self.temperatureSlider.maximumValue = 120;
        self.healthThermometerDevice.units = Fahrenheit;
    }
    else
    {
        self.minLabel.text = @"30";
        self.maxLabel.text = @"50";
        self.temperatureSlider.minimumValue = 30;
        self.temperatureSlider.maximumValue = 50;
        self.healthThermometerDevice.units = Celsius;
    }
    [self updateUI];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TemperatureType"])
    {
        OptionSelectorViewController *selector = segue.destinationViewController;
        selector.title = @"Temperature Type";
        selector.options = self.temperatureTypeOptions;
        selector.selectedOption = [self getCurrentTemperatureTypeOption];
        selector.delegate = self;
    }
}

- (Option *)getCurrentTemperatureTypeOption
{
    for (Option *option in self.temperatureTypeOptions)
    {
        if (option.value.intValue == self.healthThermometerDevice.type)
            return option;
    }
    return nil;
}

- (void)optionSelector:(OptionSelectorViewController *)optionSelector didSelectOption:(Option *)option
{
    self.healthThermometerDevice.type = option.value.intValue;
}
@end
