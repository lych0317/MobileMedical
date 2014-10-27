//
//  DeviceModel.h
//  MobileMedical
//
//  Created by li yuanchao on 14/10/27.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject

@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *macAddress;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *information;
@property (nonatomic, strong) NSString *transferType;

@end
