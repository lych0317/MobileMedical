//
//  Config.h
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StaffModel, OperatingStaff;

@interface Config : NSObject

@property (nonatomic, strong) NSNumber *userfrom; // 1——来自安卓客户端 2——来自ios客户端
@property (nonatomic, strong) NSNumber *usertype; // 1——养老院/家庭用户 2——普通患者
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) StaffModel *accountStaff;

+ (instancetype)sharedConfig;

@end
