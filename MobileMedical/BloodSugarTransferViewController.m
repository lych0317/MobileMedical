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
#import "Utils.h"
#import "BloodSugarModel.h"
#import "OperatingStaff.h"
#import "StaffModel.h"
#import "BaseResult.h"
#import "ProtocolManager.h"

@interface BloodSugarTransferViewController ()

@end

@implementation BloodSugarTransferViewController

- (void)setupCharacteristic:(LGCharacteristic *)characteristic {
//    __weak LGCharacteristic *weakCharact = characteristic;
    [characteristic setNotifyValue:YES completion:^(NSError *error) {
        if (error) {
            [self addMessage:@"设置监听失败"];
        } else {
            [self addMessage:@"设置监听成功"];
//            [self writeValueForSearchTestModel:weakCharact];
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

- (void)parseBloodSugarData:(NSData *)data {
    const Byte *bytes = data.bytes;
    BloodSugarModel *model = [[BloodSugarModel alloc] init];
    model.type = @(self.operatingStaff.bloodSugarTestType);
    model.value = @(bytes[10] / 10.0);
    NSString *dateText = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", [self intFromHex:bytes[11]], [self intFromHex:bytes[12]], [self intFromHex:bytes[13]], [self intFromHex:bytes[14]], [self intFromHex:bytes[15]], [self intFromHex:bytes[16]]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd hh:mm:ss"];
    model.date = [formatter dateFromString:dateText];
    model.mac = self.peripheral.UUIDString;
    model.pId = self.operatingStaff.staffModel.pId;
    [self addMessage:[NSString stringWithFormat:@"血糖类型：%@, 血糖值：%@, 测量时间：%@, 设备MAC地址：%@", model.type, model.value, [formatter stringFromDate:model.date], model.mac]];
    [self pushBloodSugarData:model];
}

- (void)pushBloodSugarData:(BloodSugarModel *)model {
    [Utils showProgressViewTitle:@"正在上传血糖数据"];
    [[ProtocolManager sharedManager] postBloodSugarModel:model success:^(id data) {
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

- (int)intFromHex:(int)hex {
    return (hex / 16) * 10 + hex % 16;
}

- (void)parseCommand:(NSData *)data {
    [self addMessage:[NSString stringWithFormat:@"解析命令成功：%@", [self stringFromData:data]]];
    const Byte *bytes = data.bytes;
    if (bytes[1] == 0x06) {
        if (bytes[7] == 0x00 && bytes[8] == 0x06) {
            NSString *processText;
            switch (bytes[9]) {
                case 0x01:
                    processText = @"开始测量";
                    break;
                case 0x02:
                    processText = @"设置矫正码";
                    break;
                case 0x03:
                    processText = @"插入试条";
                    break;
                case 0x04:
                    processText = @"加血";
                    break;
                case 0x05:
                    processText = @"倒计时开始";
                    break;
                case 0xfe:
                    processText = @"完成并等待结果";
                    break;
                default:
                    break;
            }
            if (processText && processText.length > 0) {
                [self addMessage:processText];
            }
        } else if (bytes[7] == 0x06 && bytes[8] == 0x01) {
            [self parseBloodSugarData:data];
        }
    }
}

//- (void)writeValueForSearchTestModel:(LGCharacteristic *)charact {
//    unsigned char bytes[7] = {0x4f, 0xff, 0xff, 0xff, 0x02, 0xff, 0xff};
//    NSData *commandData = [self createCommand:bytes length:sizeof(bytes)];
//    [charact writeValue:commandData completion:^(NSError *error) {
//        if (error) {
//            [self addMessage:[NSString stringWithFormat:@"发送数据失败：%@", [self stringFromData:commandData]]];
//        } else {
//            [self addMessage:[NSString stringWithFormat:@"发送数据成功：%@", [self stringFromData:commandData]]];
//        }
//    }];
//}
//
//- (void)writeValueForPrepareReceiveData:(LGCharacteristic *)charact {
//    unsigned char bytes[8] = {0x4f, 0x06, 0x00, 0x00, 0x03, 0x02, 0x4c, 0xfe};
//    NSData *commandData = [self createCommand:bytes length:sizeof(bytes)];
//    [charact writeValue:commandData completion:^(NSError *error) {
//        if (error) {
//            [self addMessage:[NSString stringWithFormat:@"发送数据失败：%@", [self stringFromData:commandData]]];
//        } else {
//            [self addMessage:[NSString stringWithFormat:@"发送数据成功：%@", [self stringFromData:commandData]]];
//        }
//    }];
//}

@end
