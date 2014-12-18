//
//  DataTransferTableViewController.h
//  MobileMedical
//
//  Created by li yuanchao on 14/11/29.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PERIPHERAL_NAME @"finltop"
#define SERVICE_UUID @"ff60"
#define CHARACTERISTIC_UUID @"ff61"

@class OperatingStaff, LGCentralManager, LGPeripheral, LGCharacteristic;

@interface DataTransferTableViewController : UITableViewController

@property (nonatomic, strong) OperatingStaff *operatingStaff;
@property (nonatomic, strong) NSMutableArray *instantMessages;
@property (nonatomic, strong) LGCentralManager *centralManager;
@property (nonatomic, strong) LGPeripheral *peripheral;
@property (nonatomic, strong) NSMutableData *receivedData;

- (NSString *)stringFromData:(NSData *)data;
- (NSData *)createCommand:(unsigned char *)bytes length:(size_t)length;
- (void)addMessage:(NSString *)message;

- (void)setupCharacteristic:(LGCharacteristic *)characteristic;

@end
