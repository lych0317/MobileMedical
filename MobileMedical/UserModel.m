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
        _name = @"李远超";
        _password = @"";
        _phone = @"18501340650";
        _identifier = @"130283198803175734";
    }
    return self;
}

@end
