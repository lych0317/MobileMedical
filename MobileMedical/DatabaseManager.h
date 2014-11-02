//
//  DatabaseManager.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StaffModel, ETCModel, BloodSugarModel;

@interface DatabaseManager : NSObject

+ (instancetype)sharedManager;

- (void)loadAllData;

- (void)insertStaff:(StaffModel *)model;
- (void)updateStaff:(StaffModel *)model;
- (void)deleteStaff:(StaffModel *)model;

- (void)loadETCWith:(NSString *)date;
- (void)insertETC:(ETCModel *)model;

- (void)loadBloodSugar:(NSString *)date;
- (void)insertBloodSugar:(BloodSugarModel *)model;


@end
