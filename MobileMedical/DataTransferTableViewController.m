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
#import "Utils.h"

@implementation DataTransferTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightBarButtonItem];
    self.centralManager = [LGCentralManager sharedInstance];
    self.instantMessages = [NSMutableArray array];
}

- (void)addRightBarButtonItem {
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] init];
    addButtonItem.title = @"重新读取";
    addButtonItem.target = self;
    addButtonItem.action = @selector(addButtonItemClicked:);
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)addButtonItemClicked:(UIBarButtonItem *)sender {
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scanForPeripherals];
}

- (void)scanForPeripherals {
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
            [Utils showToastWithTitle:@"查找失败，请确保蓝牙以打开" time:1];
            [self.navigationController popViewControllerAnimated:YES];
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

- (void)parseReceived:(NSData *)data {
    const Byte *bytes = data.bytes;
    if (data.length > 1 && (bytes[1] == 0x06 || bytes[1] == 0x02)) {
        self.receivedData = [NSMutableData dataWithData:data];
    } else if (self.receivedData) {
        [self.receivedData appendData:data];
    }
    if (self.receivedData && self.receivedData.length > 4) {
        bytes = self.receivedData.bytes;
        int length = bytes[4] + 6;
        while (self.receivedData.length >= length) {
            [self parseCommand:[self.receivedData subdataWithRange:NSMakeRange(0, length)]];
            self.receivedData = [NSMutableData dataWithData:[self.receivedData subdataWithRange:NSMakeRange(length, self.receivedData.length - length)]];
            if (self.receivedData.length < 5) {
                break;
            }
            bytes = self.receivedData.bytes;
            length = bytes[4] + 6;
        }
        if (self.receivedData.length == 0) {
            self.receivedData = nil;
        }
    }
}

- (void)parseCommand:(NSData *)data {}

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
