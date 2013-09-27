// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "SimulatedDevice.h"

@interface SimulatedDevice()

@property (nonatomic, strong) CBPeripheralManager *manager;
@property (nonatomic) BOOL peripheralManagerPoweredOn;

@end

@implementation SimulatedDevice

- (id)init
{
    self = [super init];
    if (self)
    {
        self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (NSString *)imageName
{
    return @"bluetooth.png";
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state)
    {
        case CBPeripheralManagerStatePoweredOn:
        {
            self.peripheralManagerPoweredOn = YES;
            if (self.on)
                [self startServices];
            break;
        }
        case CBPeripheralManagerStatePoweredOff:
        {
            self.peripheralManagerPoweredOn = NO;
            
            if(self.on)
                [self stopServices];
            break;
        }
        default:
        {
            NSLog(@"CBPeripheralManager changed state to %d", (int)peripheral.state);
            break;
        }
    }
}

- (void)setOn:(BOOL) on
{
    if (_on == on)
        return;
    
    _on = on;
    
    if (self.peripheralManagerPoweredOn)
    {
        if (_on)
            [self startServices];
        else
            [self stopServices];
    }
}

- (void)startServices
{
    NSLog(@"Starting the %@ device", self.name);
    
    for (CBMutableService *service in self.services) {
        [self.manager addService:service];
    }
}

- (void)stopServices
{
    NSLog(@"Stopping the %@ device", self.name);
    
    [self.manager removeAllServices];
    [self.manager stopAdvertising];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    if (!error)
    {
        NSDictionary *advertisingData = @{CBAdvertisementDataLocalNameKey : @"BlueSim", CBAdvertisementDataServiceUUIDsKey : @[service.UUID]};        
        [self.manager startAdvertising:advertisingData];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    request.value = [self getCharacteristicValue:request.characteristic];
    [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
}

- (NSData *)getCharacteristicValue:(CBCharacteristic *) characteristic
{
    return nil;
}

@end
