//
//  BluetoothDevice.m
//  AKBluetoothManager
//
//  Created by Infoicon on 17/04/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "BluetoothDevice.h"
#import "BluetoothDevice+Lib.h"

@implementation BluetoothDevice

- (instancetype) initWithCentral:(CBCentralManager*)central peripheral:(CBPeripheral*)peripheral
{
    if (self = [super init]) {
        _central = central;
        _peripheral = peripheral;
        peripheral.delegate = self;
    }
    return self;
}

- (void) connect
{
    [self.central connectPeripheral:self.peripheral options:nil];
}

- (void) disconnect
{
    [self.central cancelPeripheralConnection:self.peripheral];
}

#pragma mark Library

- (void) peripheralConnected
{
    [self.delegate bluetoothDeviceConnected:self];
    
    [self.peripheral discoverServices:nil];
}

#pragma mark CBPeripheralDelegate

- (void) peripheral:(CBPeripheral*)peripheral didDiscoverServices:(NSError*)error
{
    for (CBService* service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceName]]) {
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
    }
}

- (void) peripheral:(CBPeripheral*)peripheral didDiscoverCharacteristicsForService:(CBService*)service error:(NSError*)error
{
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:KCharacteristicsName]]) {
            _characteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            break;
        }
    }
}

- (void) peripheral:(CBPeripheral*)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error
{
    // establish the connection with the device
    // TODO Valid for sending commands now
}


- (void) peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error
{
    // TODO Make this not suck
    NSString* response = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
    
    if ([self.delegate respondsToSelector:@selector(bluetoothDevice:response:)])
        [self.delegate bluetoothDevice:self response:response];
}



@end
