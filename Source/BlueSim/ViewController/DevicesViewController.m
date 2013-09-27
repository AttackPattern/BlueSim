// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "DevicesViewController.h"
#import "BLEDeviceSimulator.h"
#import "SimulatedDevice.h"
#import "DevicesCollectionViewCell.h"

@interface DevicesViewController ()

@property (strong, nonatomic) BLEDeviceSimulator *simulator;

@end

@implementation DevicesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.simulator = [BLEDeviceSimulator instance];
	// Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.simulator.devices.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SimulatedDevice *device = self.simulator.devices[indexPath.item];
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Device" forIndexPath:indexPath];
    
    DevicesCollectionViewCell *deviceCell = (DevicesCollectionViewCell *)cell;
    deviceCell.deviceImageView.image = [UIImage imageNamed:device.imageName];
    deviceCell.deviceNameLabel.text = device.name;
        
    return deviceCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SimulatedDevice *device = self.simulator.devices[indexPath.item];
    
    [self performSegueWithIdentifier:device.name sender:self];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

@end
