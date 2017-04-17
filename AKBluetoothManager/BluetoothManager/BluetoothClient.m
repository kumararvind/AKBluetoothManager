//
//  BluetoothClient.m
//  AKBluetoothManager
//
//  Created by Infoicon on 17/04/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "BluetoothClient.h"
#import "BluetoothDevice+Lib.h"

@implementation BluetoothClient

- (instancetype) initWithDelegate:(id<BluetoothClientDelegate>)delegate
{
    if (self = [super init]) {
        
        _central = [[CBCentralManager alloc] initWithDelegate:self queue:NULL];
        _delegate = delegate;
        _devices = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) centralManagerDidUpdateState:(CBCentralManager*)central
{
    if (central.state == CBManagerStatePoweredOn) {
        
        NSArray* service = @[[CBUUID UUIDWithString:kServiceName]];
        [central scanForPeripheralsWithServices:service options:nil];
        
    }
}

- (void) centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI
{
    // Keep the device alive
    
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if(localName.length>0){
        
         [central stopScan]; //Ak added
        
        BluetoothDevice* device = [[BluetoothDevice alloc] initWithCentral:central peripheral:peripheral];
        self.devices[peripheral.identifier] = device;
        
        if ([self.delegate respondsToSelector:@selector(bluetoothClient:discoveredDevice:)])
            [self.delegate bluetoothClient:self discoveredDevice:device];
    }
  
}


- (void) centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral
{
    BluetoothDevice* device = self.devices[peripheral.identifier];
    [device peripheralConnected];
}

- (void) centralManager:(CBCentralManager*)central didFailToConnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    BluetoothDevice* device = self.devices[peripheral.identifier];
    
    if ([self.delegate respondsToSelector:@selector(bluetoothDevice:connectionFailed:)])
        [device.delegate bluetoothDevice:device connectionFailed:error];
}

- (void) centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    BluetoothDevice* device = self.devices[peripheral.identifier];
    
    if ([self.delegate respondsToSelector:@selector(bluetoothDeviceDisconnected:error:)])
        [device.delegate bluetoothDeviceDisconnected:device error:error];
}
@end
