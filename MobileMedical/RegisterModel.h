//
//  RegisterModel.h
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterModel : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSNumber *userfrom;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *intro;

@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *phone;

@end
