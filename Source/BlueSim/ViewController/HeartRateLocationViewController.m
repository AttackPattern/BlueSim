// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "HeartRateLocationViewController.h"
#import "BLEDeviceSimulator.h"
#import "HeartRateDevice.h"

@interface HeartRateLocationViewController ()

@end

@implementation HeartRateLocationViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sensorLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location"];
    
    cell.textLabel.text = self.sensorLocations[indexPath.row];
    cell.accessoryType = indexPath.item == self.heartRateDevice.location
        ? UITableViewCellAccessoryCheckmark
        : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:self.heartRateDevice.location inSection:0]];
    oldCell.accessoryType = UITableViewCellAccessoryNone;

    self.heartRateDevice.location = (HeartRateSensorLocation)indexPath.row;

    UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
