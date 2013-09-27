// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "TimeDevice.h"
#import <Foundation/NSNotification.h>

// Simulates a time device with:
//
//      * Current time (required)
//      * Update  (optional)
//
// https://developer.bluetooth.org/gatt/services/Pages/ServiceViewer.aspx?u=org.bluetooth.service.current_time.xml

#define TIME_SERVICE_UUID                   @"1805"
#define CURRENT_TIME_CHARACTERISTIC_UUID    @"2A2B"

#define CT_MANUAL_UPDATE        0x01
#define CT_EXTERNAL_UPDATE      0x02
#define CT_TIMEZONE_CHANGE      0x04
#define CT_DST_CHANGE           0x08

@interface TimeDevice()

@property (nonatomic, strong) CBMutableService *timeService;
@property (nonatomic, strong) CBMutableCharacteristic *currentTimeCharacteristic;

@end

@implementation TimeDevice
{
    NSArray *_services;
}

- (NSString *)name
{
    return @"Time";
}

- (NSString *)imageName
{
    return @"Time";
}

- (NSArray *)services
{
    if (!_services) _services = @[[self createTimeService]];
    return _services;
}	

- (CBMutableService *)createTimeService
{
    // Create the characteristics for the time service
    self.currentTimeCharacteristic =
        [[CBMutableCharacteristic alloc]
            initWithType:[CBUUID UUIDWithString:CURRENT_TIME_CHARACTERISTIC_UUID]
              properties:(CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify)
                   value:nil
             permissions:CBAttributePermissionsReadable];
    
    // Create the time service
    self.timeService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TIME_SERVICE_UUID] primary:YES];
    self.timeService.characteristics = @[self.currentTimeCharacteristic];
    
    return self.timeService;
}

- (void)sendManualTimeUpdate
{
    [self sendUpdateWithReason:CT_MANUAL_UPDATE];
}

- (void)sendExternalReferenceTimeUpdate
{
    [self sendUpdateWithReason:CT_EXTERNAL_UPDATE];
}

- (void)sendTimezoneChangeUpdate
{
    [self sendUpdateWithReason:CT_TIMEZONE_CHANGE];
}

- (void)sendDSTChangeUpdate
{
    [self sendUpdateWithReason:CT_DST_CHANGE];    
}

- (void)sendUpdateWithReason:(uint8_t) reason
{
    NSLog(@"Sending time update");
    
    NSMutableData *currentTimeData = [self makeCurrentTimePayload];
    uint8_t *bytes = [currentTimeData mutableBytes];
    bytes[9] = reason;
    [self.manager updateValue:currentTimeData forCharacteristic:self.currentTimeCharacteristic onSubscribedCentrals:nil];
}

- (NSData *)getCharacteristicValue:(CBCharacteristic *) characteristic
{
    if ([characteristic.UUID isEqual:self.currentTimeCharacteristic.UUID])
    {
        NSLog(@"Reading current time characteristic");
        return [self makeCurrentTimePayload];
    }
    return nil;
}

- (NSDate *)currentTime
{
    return [NSDate date];
}

- (NSMutableData *)makeCurrentTimePayload
{
    // Get the current time
    NSDate *currentTime = self.currentTime;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *time = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                                                    NSWeekdayCalendarUnit | NSDayCalendarUnit |
                                                    NSHourCalendarUnit | NSMinuteCalendarUnit |
                                                    NSSecondCalendarUnit)
                                          fromDate:currentTime];
    
    UInt16 year = time.year;
    
    // Format the time according to the Bluetooth spec
    // [year][year][month][day][hours][minutes][seconds][day of week][1/256th of a second],[Adjust Reason]
    // http://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.current_time.xml
    //
    // Note: All multi-byte data types in BLE are little-endian (see the Core Bluetooth Spec v4)
    // iOS/ARM is also little endian so we can simply copy bytes directly into the message body
    NSMutableData* data = [NSMutableData dataWithLength:10];
    uint8_t *bytes = [data mutableBytes];
    bytes[0] = ((uint8_t *)&year)[0];
    bytes[1] = ((uint8_t *)&year)[1];
    bytes[2] = (uint8_t) time.month;
    bytes[3] = (uint8_t) time.day;
    bytes[4] = (uint8_t) time.hour;
    bytes[5] = (uint8_t) time.minute;
    bytes[6] = (uint8_t) time.second;
    bytes[7] = (uint8_t) time.weekday;
    bytes[8] = 0; // 1/256th of a second
    bytes[9] = 0; // no reason given
    
    return data;
}

@end
