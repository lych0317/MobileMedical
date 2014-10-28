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

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *identifier;

@end
