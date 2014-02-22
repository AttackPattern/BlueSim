// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "TimeDeviceViewController.h"
#import "TimeDevice.h"
#import "BLEDeviceSimulator.h"
#import "BlueButton.h"

#define REFRESH_INTERVAL_SECONDS 1

@interface TimeDeviceViewController ()  <UIActionSheetDelegate>

@property (nonatomic, strong) TimeDevice *timeDevice;
@property (nonatomic, strong) NSTimer *timeRefreshTimer;

@end

@implementation TimeDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BLEDeviceSimulator *simulator = [BLEDeviceSimulator instance];
    self.timeDevice = [simulator getDeviceByName:@"Time"];
    self.powerSwitch.on = self.timeDevice.on;
    [self updateUI];
    [self updateTimeDisplay];
    
    self.timeRefreshTimer =
        [NSTimer scheduledTimerWithTimeInterval:REFRESH_INTERVAL_SECONDS
                                         target:self
                                       selector:@selector(updateTimeDisplay)
                                       userInfo:nil
                                        repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timeRefreshTimer invalidate];
    self.timeRefreshTimer = nil;
}

- (IBAction)powerSwitchChanged:(id)sender
{
    if (self.timeDevice.on != self.powerSwitch.on)
    {
        self.timeDevice.on = self.powerSwitch.on;
        [self updateUI];
    }
}

- (void)updateUI
{
    self.timeHeaderLabel.enabled = self.timeLabel.enabled = self.timeSubLabel.enabled =
        self.sendNotificationCell.textLabel.enabled = self.timeDevice.on;
    
    self.sendNotificationCell.selectionStyle = self.timeDevice.on ?
        UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
}

- (void)updateTimeDisplay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.timeLabel.text = [formatter stringFromDate:self.timeDevice.currentTime];
    
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    self.timeSubLabel.text = [formatter stringFromDate:self.timeDevice.currentTime];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1 && self.timeDevice.on)
    {
        [self showSendNotificationActionSheet];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)showSendNotificationActionSheet
{
	UIActionSheet *actionSheet =
        [[UIActionSheet alloc] initWithTitle:@"Send Notification"
                                    delegate:self
                           cancelButtonTitle:@"Cancel"
                      destructiveButtonTitle:nil
                           otherButtonTitles:@"Manual Time Update", @"External Time Update", @"Timezone Change", @"DST Change", nil];
    
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
            [self.timeDevice sendManualTimeUpdate];
            break;
        case 1:
            [self.timeDevice sendExternalReferenceTimeUpdate];
            break;
        case 2:
            [self.timeDevice sendTimezoneChangeUpdate];
            break;
        case 3:
            [self.timeDevice sendDSTChangeUpdate];
            break;
    }
    // TODO: deselect the cell
}

@end