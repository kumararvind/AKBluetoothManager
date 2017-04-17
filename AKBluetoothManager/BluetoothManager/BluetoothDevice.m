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
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:KCharNameFeatured]]) {
            _characteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            break;
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:KCharMeasurementNameFeatured]]) {
            _characteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            break;
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:KCharSpeedMeasurement]]) {
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
    
    /*power measurement changed*/
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:KCharMeasurementNameFeatured]])
    {
        
        if( (characteristic.value)  || !error )
        {
            //[self updateWithBSCData:characteristic.value];
            [self updatewith:characteristic.value];
          //  [self updateWithSBPData:characteristic.value];
           // [peripheralDelegate PowerPodServiceDidChangePowerMeasurent:self];
            return;
        }
    }
    
  
    // TODO Make this not suck
    NSString* response = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
    
    if ([self.delegate respondsToSelector:@selector(bluetoothDevice:response:)])
        [self.delegate bluetoothDevice:self response:response];
}


// Testing with powerpod
// Power pod tested
-(void)updatewith:(NSData *)data
{
    
    const uint8_t *reportData = [data bytes];
    
    NSLog(@"SBPData: %hu, %hu, %hu, %hu , %hu, %hu, %hu, %hu, %hu,%hu, %hu, %hu, %hu, %hu\n", CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1])), CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[2])), CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[3])), CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[4])),CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[5])),CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[6])),CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[7])),CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[8])),CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[9])),CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[10])),CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[11])),CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[12])),CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[13])),
          CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[14])));
}


#pragma mark Raw command

- (void) sendCommand:(NSString*)command
{
    NSData* data = [[command stringByAppendingString:@"\r"] dataUsingEncoding:NSASCIIStringEncoding];
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
}

@end
