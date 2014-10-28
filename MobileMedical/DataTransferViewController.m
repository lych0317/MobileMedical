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
    [LGCentralManager sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:100 completion:^(NSArray *peripherals) {
        [peripherals enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LGPeripheral *peripheral = obj;
            NSLog(@"peripheral name is %@, uuid is %@", peripheral.name, peripheral.UUIDString);
            if ([peripheral.name isEqualToString:@"finltop"]) {
                [self testPeripheral:peripheral];
            }
        }];
    }];
}

- (void)testPeripheral:(LGPeripheral *)peripheral
{
    // First of all connecting to peripheral
    [peripheral connectWithCompletion:^(NSError *error) {
        // Discovering services of peripheral
        [peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
            for (LGService *service in services) {
                NSLog(@"service uuid is %@", service.UUIDString);
                // Finding out our service
//                if ([service.UUIDString isEqualToString:@"5ec0"]) {
                    // Discovering characteristics of our service
                    [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
                        // We need to count down completed operations for disconnecting
                        __block int i = 0;
                        for (LGCharacteristic *charact in characteristics) {
                            NSLog(@"charact uuid is %@", charact.UUIDString);
                            // cef9 is a writabble characteristic, lets test writting
//                            if ([charact.UUIDString isEqualToString:@"cef9"]) {
//                                [charact writeByte:0xFF completion:^(NSError *error) {
//                                    if (++i == 3) {
//                                        // finnally disconnecting
//                                        [peripheral disconnectWithCompletion:nil];
//                                    }
//                                }];
//                            } else {
//                                // Other characteristics are readonly, testing read
                                [charact readValueWithBlock:^(NSData *data, NSError *error) {
//                                    if (++i == 3) {
                                        // finnally disconnecting
//                                        [peripheral disconnectWithCompletion:nil];
//                                    }
                                    NSLog(@"======================");
                                    const Byte *bytes = [data bytes];
                                    for (int i = 0; data.length; i++) {
                                        NSLog(@"i = %d, byte is %u", i, bytes[i]);
                                    }
                                    NSLog(@"====================");
                                }];
//                            }
                        }
                    }];
//                }
            }
        }];
    }];
}


@end
