//
//  DataTransferViewController.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DataTransferViewController.h"
#import <LGBluetooth/LGBluetooth.h>
#import "Utils.h"

@interface DataTransferViewController ()

@end

@implementation DataTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:10 completion:^(NSArray *peripherals) {
        [peripherals enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LGPeripheral *peripheral = obj;
            NSLog(@"peripheral name is %@, uuid is %@", peripheral.name, peripheral.UUIDString);
        }];
    }];
}

@end
