//
//  BluetoothDevice+Lib.h
//  AKBluetoothManager
//
//  Created by Infoicon on 17/04/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "BluetoothDevice.h"

static NSString *kServiceName = @"ffe0";
static NSString *KCharacteristicsName = @"ffe1";

@class BluetoothDevice;
@interface BluetoothDevice(Lib)

- (instancetype) initWithCentral:(CBCentralManager*)central peripheral:(CBPeripheral*)peripheral;

- (void) peripheralConnected;

@end

