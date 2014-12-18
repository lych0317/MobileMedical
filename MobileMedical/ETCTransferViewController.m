//
//  ETCTransferViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/12/17.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "ETCTransferViewController.h"
#import <LGBluetooth/LGBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Constants.h"
#import "Utils.h"
#import "ETCModel.h"
#import "OperatingStaff.h"
#import "StaffModel.h"
#import "BaseResult.h"
#import "ProtocolManager.h"

@interface ETCTransferViewController ()

@property (nonatomic, strong) ETCModel *etcModel;
@property (nonatomic, strong) NSMutableString *ecgText;

@end

@implementation ETCTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ecgText = [NSMutableString string];
    self.etcModel = [[ETCModel alloc] init];
    self.etcModel.pId = self.operatingStaff.staffModel.pId;
}

- (void)setupPeripheral:(LGPeripheral *)peripheral {
    [super setupPeripheral:peripheral];
}

- (void)setupCharacteristic:(LGCharacteristic *)characteristic {
    __weak LGCharacteristic *weakCharact = characteristic;
    [characteristic setNotifyValue:YES completion:^(NSError *error) {
        if (error) {
            [self addMessage:@"设置监听失败"];
        } else {
            [self addMessage:@"设置监听成功"];
            [self writeValueForPrepareReceiveData:weakCharact];
        }
    } onUpdate:^(NSData *data, NSError *error) {
        if (error) {
            [self addMessage:@"接收数据失败"];
        } else {
            [self addMessage:[NSString stringWithFormat:@"接收数据成功：%@", [self stringFromData:data]]];
            [self parseReceived:data];
        }
    }];
}

- (void)parseCommand:(NSData *)data {
    [self addMessage:[NSString stringWithFormat:@"解析命令成功：%@", [self stringFromData:data]]];
    const Byte *bytes = data.bytes;
    if (bytes[1] == 0x02) {
        if (bytes[7] == 0x02) {
            self.etcModel.pulse = @(bytes[10]);
            int length = bytes[4];
            for (int i = 11; i <= length + 4; i++) {
                [self.ecgText appendFormat:@"%d,", bytes[i]];
            }
        } else if (bytes[7] == 0xfe) {
            self.etcModel.ecg = self.ecgText;
            self.etcModel.date = [NSDate date];
            [self postETCData];
        }
    }
}

- (void)postETCData {
    [Utils showProgressViewTitle:@"正在上传心电数据"];
    [[ProtocolManager sharedManager] postETCModel:self.etcModel success:^(id data) {
        [Utils hideProgressViewAfter:0];
        BaseResult *result = data;
        if ([result.return_code intValue] == 0) {
            [Utils showToastWithTitle:@"上传成功" time:1];
        } else {
            [Utils showToastWithTitle:@"上传失败" time:1];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils hideProgressViewAfter:0];
        [Utils showToastWithTitle:@"上传失败" time:1];
    }];
}

- (void)writeValueForPrepareReceiveData:(LGCharacteristic *)charact {
    unsigned char bytes[8] = {0x5f, 0x02, 0x00, 0x00, 0x03, 0x00, 0x01, 0xfe};
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
