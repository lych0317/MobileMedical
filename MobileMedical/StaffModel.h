//
//  StaffModel.h
//  MobileMedical
//
//  Created by li yuanchao on 14/10/23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffModel : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *chengwei;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *doctorIds;
@property (nonatomic, strong) NSNumber *paytype;
@property (nonatomic, strong) NSNumber *opr;

@property (nonatomic, strong) NSDictionary *hospitalDoctorMap;

@end
