//
//  AppModel.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "AppModel.h"
#import "StaffModel.h"
#import "CollectionModel.h"
#import "Constants.h"

static AppModel *sAppModel = nil;

@implementation AppModel

+ (instancetype)sharedAppModel {
    if (sAppModel == nil) {
        sAppModel = [[AppModel alloc] init];
    }
    return sAppModel;
}

#pragma mark - Getters

- (NSArray *)staffs {
    if (_staffs == nil) {
        StaffModel *model = [[StaffModel alloc] init];
        model.name = @"张三";
        model.gender = @(0);
        model.relation = @"父亲";
        model.phone = @"150xxxxxxxx";
        model.identifier = @"130xxxxxxxxxxxxxxx";
        model.birthday = [NSDate date];
        model.payType = @(0);
        model.hospital = @"北京肛肠医院";
        model.doctor = @"李大夫";
        CollectionModel *collection = [[CollectionModel alloc] init];
        collection.collectionDevice = @"E100";
        collection.collectionType = @"心电图";
        model.collectionModels = @[collection];
        _staffs = @[model];
    }
    return _staffs;
}





















@end
