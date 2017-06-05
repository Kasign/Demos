//
//  ViewController.m
//  BlueBlooth
//
//  Created by walg on 2017/4/13.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (strong ,nonatomic) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (strong,nonatomic) NSMutableArray *nDevices;
@property (strong,nonatomic) NSMutableArray *nServices;
@property (strong,nonatomic) NSMutableArray *nCharacteristics;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nDevices = [[NSMutableArray alloc]init];
    _nServices = [[NSMutableArray alloc]init];
    _nCharacteristics = [[NSMutableArray alloc]init];
    
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [_manager scanForPeripheralsWithServices:nil options:nil];
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开,请扫描外设");
            [_manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FF15"]]  options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        }
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"蓝牙没有打开,请先打开蓝牙");
            break;
        default:
            break;
    }
//    NSLog(@"已经连接到:%@", _peripheral.description);
//    _peripheral.delegate = self;
//    [central stopScan];
//    [_peripheral discoverServices:nil];
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@",[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier, advertisementData]);
    
    _peripheral = peripheral;
    [_manager connectPeripheral:_peripheral options:nil];
    
    [self.manager stopScan];
    
    
    BOOL replace = NO;
    // Match if we have this device from before
    for (int i=0; i < _nDevices.count; i++) {
        CBPeripheral *p = [_nDevices objectAtIndex:i];
        if ([p isEqual:peripheral]) {
            [_nDevices replaceObjectAtIndex:i withObject:peripheral];
            replace = YES;
        }
    }
    if (!replace) {
        [_nDevices addObject:peripheral];
    }
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier]);
    
    NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier]);
    
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];
     NSLog(@"扫描服务");
}
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"失败：%@",error);
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_peripheral,pow(10,ci)];
    NSLog(@"%@", [NSString stringWithFormat:@"距离：%@", length]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
