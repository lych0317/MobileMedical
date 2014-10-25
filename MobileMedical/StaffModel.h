//
//  StaffModel.h
//  MobileMedical
//
//  Created by li yuanchao on 14/10/23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSString *relation;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSNumber *payType;
@property (nonatomic, strong) NSString *hospital;
@property (nonatomic, strong) NSString *doctor;
@property (nonatomic, strong) NSArray *collectionModels;

@end
