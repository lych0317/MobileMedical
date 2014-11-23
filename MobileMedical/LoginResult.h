//
//  LoginResult.h
//  MobileMedical
//
//  Created by li yuanchao on 14/10/28.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResult.h"

@interface LoginResult : BaseResult

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSNumber *usertype;
@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *chengwei;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *doctorIds;
@property (nonatomic, strong) NSNumber *paytype;

@end
