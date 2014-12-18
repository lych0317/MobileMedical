//
//  DataTransferTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/29.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DataTransferTableViewController.h"
#import <LGBluetooth/LGBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Constants.h"

@implementation DataTransferTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centralManager = [LGCentralManager sharedInstance];
    self.instantMessages = [NSMutableArray array];
}

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
    self.peripheral = peripheral;
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

- (void)setupCharacteristic:(LGCharacteristic *)characteristic {}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.peripheral disconnectWithCompletion:nil];
}

- (NSString *)stringFromData:(NSData *)data {
    NSMutableString *retStr = [NSMutableString string];
    const Byte *bytes = data.bytes;
    for (int i = 0; i < data.length; i++) {
        [retStr appendFormat:@"0x%x%x ", bytes[i] >> 4, bytes[i] & 0x0f];
    }
    return retStr;
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

- (void)addMessage:(NSString *)message {
    NSLog(@"%@", message);
    [self.instantMessages insertObject:message atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instantMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = -1;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.instantMessages[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *message = self.instantMessages[indexPath.row];
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    int lineCount = (size.width + CGRectGetWidth(tableView.frame)) / CGRectGetWidth(tableView.frame);
    float height = lineCount * (size.height + 20);
    if (height < 44) {
        height = 44;
    }
    return height;
}

@end
