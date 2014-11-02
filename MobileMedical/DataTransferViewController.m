//
//  DataTransferViewController.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DataTransferViewController.h"
#import <LGBluetooth/LGBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Utils.h"
#import "Constants.h"

#define PERIPHERAL_NAME @"finltop"
#define SERVICE_UUID @"ff60"
#define CHARACTERISTIC_UUID @"ff61"

@interface DataTransferViewController ()

@property (nonatomic, assign, getter=isSimpleTestModel) BOOL simpleTestModel;
@property (nonatomic, assign) NSUInteger receivedDataFrom;
@property (nonatomic, assign) NSUInteger receivedDataTo;
@property (nonatomic, assign) NSUInteger receivedStatus;
@property (nonatomic, assign) NSUInteger receivedBPM;
@property (nonatomic, strong) NSMutableData *receivedECGData;

@property (nonatomic, assign) DeviceType deviceType;

@end

@implementation DataTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LGCentralManager sharedInstance];
    self.receivedECGData = [NSMutableData data];
    if (self.etcModel) {
        self.deviceType = DeviceTypeETC;
    } else if (self.bloodSugarModel) {
        self.deviceType = DeviceTypeBloodSugar;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Utils showProgressViewTitle:@"查找外部蓝牙设备。。。"];
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:50 completion:^(NSArray *peripherals) {
        __block BOOL foundPeripheral = NO;
        [peripherals enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LGPeripheral *peripheral = obj;
            NSLog(@"peripheral name is %@, uuid is %@", peripheral.name, peripheral.UUIDString);
            if ([peripheral.name isEqualToString:PERIPHERAL_NAME]) {
                [Utils switchProgressViewTitle:@"成功找到蓝牙设备"];
                foundPeripheral = YES;
                switch (self.deviceType) {
                    case DeviceTypeETC:
                        [self setupETCPeripheral:peripheral];
                        break;
                    case DeviceTypeBloodSugar:
                        [self setupBloodSugarPeripheral:peripheral];
                        break;
                    default:
                        break;
                }
            }
        }];
        if (foundPeripheral == NO) {
            [Utils hideProgressViewWithTitle:@"未发现蓝牙设备" after:1 completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)setupETCPeripheral:(LGPeripheral *)peripheral {
    __weak DataTransferViewController *weakSelf = self;
    [Utils switchProgressViewTitle:@"连接蓝牙设备。。。"];
    [peripheral connectWithCompletion:^(NSError *error) {
        if (error == nil) {
            [Utils switchProgressViewTitle:@"成功连接蓝牙设备"];
            [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
                BOOL foundService = NO;
                for (LGService *service in services) {
                    if ([service.UUIDString isEqualToString:SERVICE_UUID]) {
                        foundService = YES;
                        [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                            BOOL foundCharacteristic = NO;
                            for (LGCharacteristic *charact in characteristics) {
                                __weak LGCharacteristic *weakCharact = charact;
                                if ([charact.UUIDString isEqualToString:CHARACTERISTIC_UUID]) {
                                    foundCharacteristic = YES;
                                    [Utils switchProgressViewTitle:@"探查测量模式。。。"];
                                    [charact setNotifyValue:YES completion:^(NSError *error) {
                                        if (error) {
                                            [Utils hideProgressViewWithTitle:@"设置监听失败" after:1 completionBlock:^{
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }];
                                        }
                                    } onUpdate:^(NSData *data, NSError *error) {
                                        if (error == nil) {
                                            const unsigned char *bytes = data.bytes;
                                            if (data.length > 9 && bytes[0] == 0x5f && bytes[1] == 0x02 && bytes[7] == 0xfc) {
                                                if (bytes[8] == 0x01) {
                                                    [Utils switchProgressViewTitle:@"准备接收简易测量数据"];
                                                    weakSelf.simpleTestModel = YES;
                                                    [weakSelf writeValueForSearchDataModel:weakCharact];
                                                } else if (bytes[8] == 0x02) {
                                                    [Utils switchProgressViewTitle:@"准备接收复杂测量数据"];
                                                    weakSelf.simpleTestModel = NO;
                                                }
                                            } else if (data.length > 10 && bytes[0] == 0x5f && bytes[1] == 0x02 && bytes[7] == 0x00 && bytes[8] == 0x05) {
                                                if (bytes[9] == 0) {
                                                    weakSelf.receivedDataFrom = bytes[9];
                                                    weakSelf.receivedDataTo = bytes[9];
                                                } else {
                                                    weakSelf.receivedDataFrom = bytes[9];
                                                    weakSelf.receivedDataTo = bytes[9];
                                                }
                                                [weakSelf writeValueForReceiveData:weakCharact];
                                            } else if (data.length > 4 && (bytes[0] & 0xf0)  == 0x40 && bytes[1] == 0x02 && bytes[7] == 0x02) {
                                                if (weakSelf.isSimpleTestModel) {
                                                    // 简易测量模式数据
                                                    NSLog(@"received ecg data");
                                                    unsigned int index = bytes[0] & 0x0f;
                                                    if (weakSelf.receivedDataFrom <= index && index <= weakSelf.receivedDataTo) {
                                                        weakSelf.receivedStatus = bytes[8];
                                                        weakSelf.receivedBPM = bytes[9];
                                                        for (int i = 0; i < data.length; i++) {
                                                            NSLog(@"index: %u, received data: %u", i, bytes[i]);
                                                        }
                                                    }
                                                } else {
                                                    // 复杂测量模式数据
                                                }
                                            }
                                        } else {
                                            [Utils hideProgressViewWithTitle:@"接收数据失败" after:1 completionBlock:^{
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }];
                                        }
                                    }];
                                    [weakSelf writeValueForSearchTestModel:charact];
                                }
                            }
                            if (foundCharacteristic == NO) {
                                [Utils hideProgressViewWithTitle:@"解析蓝牙设备失败" after:1 completionBlock:^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                            }
                        }];
                    }
                }
                if (foundService == NO) {
                    [Utils hideProgressViewWithTitle:@"解析蓝牙设备失败" after:1 completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
                }
            }];
        } else {
            [Utils hideProgressViewWithTitle:@"连接蓝牙设备失败" after:1 completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)setupBloodSugarPeripheral:(LGPeripheral *)peripheral {
    __weak DataTransferViewController *weakSelf = self;
    [Utils switchProgressViewTitle:@"连接蓝牙设备。。。"];
    [peripheral connectWithCompletion:^(NSError *error) {
        if (error == nil) {
            [Utils switchProgressViewTitle:@"成功连接蓝牙设备"];
            [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
                BOOL foundService = NO;
                for (LGService *service in services) {
                    if ([service.UUIDString isEqualToString:SERVICE_UUID]) {
                        foundService = YES;
                        [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                            BOOL foundCharacteristic = NO;
                            for (LGCharacteristic *charact in characteristics) {
                                __weak LGCharacteristic *weakCharact = charact;
                                if ([charact.UUIDString isEqualToString:CHARACTERISTIC_UUID]) {
                                    foundCharacteristic = YES;
                                    [Utils switchProgressViewTitle:@"探查测量模式。。。"];
                                    [charact setNotifyValue:YES completion:^(NSError *error) {
                                        if (error) {
                                            [Utils hideProgressViewWithTitle:@"设置监听失败" after:1 completionBlock:^{
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }];
                                        }
                                    } onUpdate:^(NSData *data, NSError *error) {
                                        if (error == nil) {
                                            const unsigned char *bytes = data.bytes;
                                            NSLog(@"received data length: %d", data.length);
                                            for (int i = 0; i < data.length; i++) {
                                                NSLog(@"index: %d, data: %u", i, bytes[i]);
                                            }
                                            if (data.length > 9 && bytes[1] == 0x06 && bytes[7] == 0xfc) {
//                                                if (bytes[8] == 0x01) {
                                                    [Utils switchProgressViewTitle:@"准备接收简易测量数据"];
//                                                    weakSelf.simpleTestModel = YES;
                                                    [weakSelf writeValueForSearchDataModel:weakCharact];
//                                                } else if (bytes[8] == 0x02) {
//                                                    [Utils switchProgressViewTitle:@"准备接收复杂测量数据"];
//                                                    weakSelf.simpleTestModel = NO;
//                                                }
                                            } else if (data.length > 10 && bytes[1] == 0x06 && bytes[7] == 0x00 && bytes[8] == 0x05) {
                                                if (bytes[9] == 0) {
                                                    weakSelf.receivedDataFrom = bytes[9];
                                                    weakSelf.receivedDataTo = bytes[9];
                                                } else {
                                                    weakSelf.receivedDataFrom = bytes[9];
                                                    weakSelf.receivedDataTo = bytes[9];
                                                }
                                                [weakSelf writeValueForReceiveData:weakCharact];
                                            } else if (data.length > 4 && (bytes[0] & 0xf0)  == 0x40 && bytes[1] == 0x06 && bytes[7] == 0x02) {
                                                if (weakSelf.isSimpleTestModel) {
                                                    // 简易测量模式数据
                                                    NSLog(@"received blood sugar data");
                                                    unsigned int index = bytes[0] & 0x0f;
                                                    if (weakSelf.receivedDataFrom <= index && index <= weakSelf.receivedDataTo) {
                                                        weakSelf.receivedStatus = bytes[8];
                                                        weakSelf.receivedBPM = bytes[9];
                                                        for (int i = 0; i < data.length; i++) {
                                                            NSLog(@"index: %u, received data: %u", i, bytes[i]);
                                                        }
                                                    }
                                                } else {
                                                    // 复杂测量模式数据
                                                }
                                            }
                                        } else {
                                            [Utils hideProgressViewWithTitle:@"接收数据失败" after:1 completionBlock:^{
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }];
                                        }
                                    }];
                                    [weakSelf writeValueForSearchTestModel:charact];
                                }
                            }
                            if (foundCharacteristic == NO) {
                                [Utils hideProgressViewWithTitle:@"解析蓝牙设备失败" after:1 completionBlock:^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                            }
                        }];
                    }
                }
                if (foundService == NO) {
                    [Utils hideProgressViewWithTitle:@"解析蓝牙设备失败" after:1 completionBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }];
        } else {
            [Utils hideProgressViewWithTitle:@"连接蓝牙设备失败" after:1 completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)writeValueForSearchTestModel:(LGCharacteristic *)charact {
    unsigned char bytes[8] = {0x4f, 0x02, 0xff, 0xff, 0x03, 0xff, 0xff, 0xfc};
    switch (self.deviceType) {
        case DeviceTypeETC:
            break;
        case DeviceTypeBloodSugar:
            bytes[1] = 0x06;
            break;
        default:
            break;
    }
    [charact writeValue:[self createCommand:bytes length:sizeof(bytes)] completion:^(NSError *error) {

    }];
}

- (void)writeValueForSearchDataModel:(LGCharacteristic *)charact {
    unsigned char bytes[9] = {0x4f, 0x02, 0xff, 0xff, 0x04, 0xff, 0xff, 0x00, 0x05};
    switch (self.deviceType) {
        case DeviceTypeETC:
            break;
    case DeviceTypeBloodSugar:
            bytes[1] = 0x06;
            break;
        default:
            break;
    }
    [charact writeValue:[self createCommand:bytes length:sizeof(bytes)] completion:^(NSError *error) {

    }];
}

- (void)writeValueForReceiveData:(LGCharacteristic *)charact {
    unsigned char bytes[] = {0x5f, 0x02, 0xff, 0xff, 0x03, 0xff, 0xff, 0xfe};
    switch (self.deviceType) {
        case DeviceTypeETC:
            break;
        case DeviceTypeBloodSugar:
            bytes[1] = 0x06;
            break;
        default:
            break;
    }
    [charact writeValue:[self createCommand:bytes length:sizeof(bytes)] completion:^(NSError *error) {

    }];
}

- (NSData *)createCommand:(unsigned char *)bytes length:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithBytes:bytes length:length];
    unsigned char flag = 0;
    for (int i = 0; i < length; i++) {
        flag ^= bytes[i];
    }
    const unsigned char flags[] = {flag};
    [data appendBytes:flags length:sizeof(flags)];
    return data;
}


@end
