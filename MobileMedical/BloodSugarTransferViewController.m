//
//  BloodSugarTransferViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/12/17.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "BloodSugarTransferViewController.h"
#import <LGBluetooth/LGBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Constants.h"

@interface BloodSugarTransferViewController ()

@end

@implementation BloodSugarTransferViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addMessage:@"查找外部蓝牙设备..."];
    [self.centralManager scanForPeripheralsByInterval:2 completion:^(NSArray *peripherals) {
        __block BOOL foundDevice = NO;
        [peripherals enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LGPeripheral *peripheral = obj;
            [self addMessage:[NSString stringWithFormat:@"发现外部蓝牙设备 - %@", peripheral.name]];
            if ([peripheral.name isEqualToString:PERIPHERAL_NAME]) {
                foundDevice = YES;
                [self setupPeripheral:peripheral];
            }
        }];
        if (!foundDevice) {
            [self addMessage:@"未发现对应蓝牙设备"];
        }
    }];
}

- (void)setupPeripheral:(LGPeripheral *)peripheral {
    [self addMessage:[NSString stringWithFormat:@"正在连接 %@ ...", peripheral.name]];
    [LGUtils discoverCharactUUID:CHARACTERISTIC_UUID serviceUUID:SERVICE_UUID peripheral:peripheral completion:^(LGCharacteristic *characteristic, NSError *error) {
        if (error) {
            [self addMessage:@"连接失败"];
        } else {
            [self addMessage:@"连接成功，设置监听，准备接收数据"];
            [self setupCharacteristic:characteristic];
        }
    }];
}

- (void)setupCharacteristic:(LGCharacteristic *)characteristic {
    __weak LGCharacteristic *weakCharact = characteristic;
    [characteristic setNotifyValue:YES completion:^(NSError *error) {
        if (error) {
            [self addMessage:@"设置监听失败"];
        } else {
            [self addMessage:@"设置监听成功"];
            [self writeValueForSearchTestModel:weakCharact];
        }
    } onUpdate:^(NSData *data, NSError *error) {
        if (error) {
            [self addMessage:@"接收数据失败"];
        } else {
            [self addMessage:[NSString stringWithFormat:@"接收数据成功：%@", [self stringFromData:data]]];
            const Byte *bytes = data.bytes;
            if (data.length == 8) {
                if (bytes[0] == 0x5f && bytes[1] == 0x06) {
                    [self writeValueForPrepareReceiveData:weakCharact];
                }
            }
        }
    }];
}

- (void)writeValueForSearchTestModel:(LGCharacteristic *)charact {
    unsigned char bytes[7] = {0x4f, 0xff, 0xff, 0xff, 0x02, 0xff, 0xff};
    NSData *commandData = [self createCommand:bytes length:sizeof(bytes)];
    [charact writeValue:commandData completion:^(NSError *error) {
        if (error) {
            [self addMessage:[NSString stringWithFormat:@"发送数据失败：%@", [self stringFromData:commandData]]];
        } else {
            [self addMessage:[NSString stringWithFormat:@"发送数据成功：%@", [self stringFromData:commandData]]];
        }
    }];
}

- (void)writeValueForPrepareReceiveData:(LGCharacteristic *)charact {
    unsigned char bytes[11] = {0x4f, 0x06, 0x00, 0x00, 0x07, 0x02, 0x4c, 0x00, 0x05, 0xfa, 0xfa};
    NSData *commandData = [self createCommand:bytes length:sizeof(bytes)];
    [charact writeValue:commandData completion:^(NSError *error) {
        if (error) {
            [self addMessage:[NSString stringWithFormat:@"发送数据失败：%@", [self stringFromData:commandData]]];
        } else {
            [self addMessage:[NSString stringWithFormat:@"发送数据成功：%@", [self stringFromData:commandData]]];
        }
    }];
}

@end
