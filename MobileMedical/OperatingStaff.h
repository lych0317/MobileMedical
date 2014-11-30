//
//  OperatingStaff.h
//  MobileMedical
//
//  Created by li yuanchao on 14/11/30.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class StaffModel;

@interface OperatingStaff : NSObject

@property (nonatomic, assign) OperationType operationType;
@property (nonatomic, assign) TestType testType;
@property (nonatomic, assign) DeviceTestType deviceTestType;
@property (nonatomic, assign) OtherTestType otherTestType;
@property (nonatomic, assign) BloodSugarTestType bloodSugarTestType;

@property (nonatomic, strong) StaffModel *staffModel;

@end
