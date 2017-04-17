//
//  BluetoothClient.h
//  AKBluetoothManager
//
//  Created by Infoicon on 17/04/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;


@class BluetoothDevice;
@protocol BluetoothClientDelegate;

@interface BluetoothClient : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

- (instancetype) initWithDelegate:(id<BluetoothClientDelegate>)delegate;

@property (nonatomic, readonly) CBCentralManager* central;
@property (nonatomic, readonly) id<BluetoothClientDelegate> delegate;
@property (nonatomic, readonly) NSMutableDictionary* devices;

@end


@protocol BluetoothClientDelegate <NSObject>

- (void) bluetoothClient:(BluetoothClient*)client discoveredDevice:(BluetoothDevice*)device;

@end
