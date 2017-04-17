//
//  BluetoothDevice+Lib.h
//  AKBluetoothManager
//
//  Created by Infoicon on 17/04/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "BluetoothDevice.h"

static NSString *kServiceName = @"1818";
static NSString *KCharNameFeatured = @"2A65";
static NSString *KCharMeasurementNameFeatured = @"2A63";
static NSString *KCharSpeedMeasurement = @"2A5D";


@class BluetoothDevice;
@interface BluetoothDevice(Lib)

- (instancetype) initWithCentral:(CBCentralManager*)central peripheral:(CBPeripheral*)peripheral;

- (void) peripheralConnected;

@end

