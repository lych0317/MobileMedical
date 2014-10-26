//
//  DatabaseManager.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StaffModel;

@interface DatabaseManager : NSObject

+ (instancetype)sharedManager;

- (void)loadAllData;

- (void)insertStaff:(StaffModel *)model;

- (void)updateStaff:(StaffModel *)model;

- (void)deleteStaff:(StaffModel *)model;

@end
