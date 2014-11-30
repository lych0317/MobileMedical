//
//  Config.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "Config.h"
#import "StaffModel.h"

static Config *sConfig = nil;

@implementation Config

+ (instancetype)sharedConfig {
    if (sConfig == nil) {
        sConfig = [[Config alloc] init];
        sConfig.userfrom = @(2);
    }
    return sConfig;
}

- (StaffModel *)accountStaff {
    if (_accountStaff == nil) {
        _accountStaff = [[StaffModel alloc] init];
    }
    return _accountStaff;
}

@end
