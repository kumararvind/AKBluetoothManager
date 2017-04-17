//
//  BluetoothDevice.h
//  AKBluetoothManager
//
//  Created by Infoicon on 17/04/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@import CoreBluetooth;

@protocol BluetoothDeviceDelegate;

@interface BluetoothDevice : NSObject<CBPeripheralDelegate>

typedef enum {
    kReadAutoMode,
    kReadManualMode,
    kWriteAutoMode,
    kWriteManualMode
} Mode;


// TODO Turn these into a block based API
- (void) connect;
- (void) disconnect;
@property (nonatomic, weak) id<BluetoothDeviceDelegate> delegate;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* identifier;

@property (nonatomic, readonly) CBCentralManager* central;
@property (nonatomic, readonly) CBPeripheral* peripheral;
@property (nonatomic, readonly) CBCharacteristic* characteristic;
@property(nonatomic) Mode mode;


// TODO program and few remaining commands
- (void) sendCommand:(NSString*)command;

@end

@protocol BluetoothDeviceDelegate <NSObject>

- (void) bluetoothDeviceConnected:(BluetoothDevice*)device;
- (void) bluetoothDevice:(BluetoothDevice*)device connectionFailed:(NSError*)error;
- (void) bluetoothDeviceDisconnected:(BluetoothDevice*)device error:(NSError*)error;
- (void) bluetoothDevice:(BluetoothDevice*)device response:(NSString*)response;

@end
