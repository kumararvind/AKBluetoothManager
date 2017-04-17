//
//  ViewController.m
//  AKBluetoothManager
//
//  Created by Infoicon on 17/04/17.
//  Copyright © 2017 InfoiconTechnologies. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothDevice.h"
#import "BluetoothClient.h"

@interface ViewController ()<BluetoothClientDelegate,BluetoothDeviceDelegate>

@property (nonatomic,strong)BluetoothDevice *device;
@property (nonatomic,strong)BluetoothClient *client;

@end

@implementation ViewController
@synthesize device=_device;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    _client = [[BluetoothClient alloc]initWithDelegate:self];
    
}

- (void) bluetoothClient:(BluetoothClient*)client discoveredDevice:(BluetoothDevice*)device
{
    _device = device;
    device.delegate = self;
    [device connect];
}

- (void) bluetoothDeviceConnected:(BluetoothDevice *)device
{
    NSLog(@"Connected");
}

- (void) bluetoothDevice:(BluetoothDevice*)device connectionFailed:(NSError*)error
{
    NSLog(@"Failed connection");
}

- (void) bluetoothDeviceDisconnected:(BluetoothDevice*)device error:(NSError*)error
{
    NSLog(@"Disconnected %@", error);
}

- (void) bluetoothDevice:(BluetoothDevice*)device response:(NSString*)response
{
    NSLog(@"Response: %@", response);
}

- (IBAction)_onClick:(id)sender
{
    [self.device sendCommand:@""];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
