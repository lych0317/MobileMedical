//
//  UserModel.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/28.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _name = @"zhh";
        _password = @"111111";
//        _phone = @"13911918140";
//        _identifier = @"110108197610286325";
    }
    return self;
}

@end
