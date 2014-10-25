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
        model.gender = self.genderTitles[0];
        model.relation = @"父亲";
        model.phone = @"150xxxxxxxx";
        model.identifier = @"130xxxxxxxxxxxxxxx";
        model.birthday = [NSDate date];
        model.payType = self.payTypeTitles[0];
        model.hospital = self.hospitalAndDoctorTitleMap.allKeys[0];
        model.doctor = self.hospitalAndDoctorTitleMap.allValues[0][0];
        CollectionModel *collection = [[CollectionModel alloc] init];
        collection.collectionDevice = self.collectionDeviceTitles[0];
        collection.collectionType = self.collectionTypeTitles[0];
        model.collectionModels = @[collection];
        _staffs = @[model];
    }
    return _staffs;
}

- (NSArray *)genderTitles {
    if (_genderTitles == nil) {
        _genderTitles = @[@"男", @"女"];
    }
    return _genderTitles;
}

- (NSArray *)payTypeTitles {
    if (_payTypeTitles == nil) {
        _payTypeTitles = @[@"支付宝", @"微信", @"其他"];
    }
    return _payTypeTitles;
}

- (NSDictionary *)hospitalAndDoctorTitleMap {
    if (_hospitalAndDoctorTitleMap == nil) {
        _hospitalAndDoctorTitleMap = @{@"北京肛肠医院": @[@"张大夫", @"马大夫", @"王大夫"], @"北京301医院": @[@"张大夫", @"马大夫", @"王大夫"], @"北京天坛医院": @[@"张大夫", @"马大夫", @"王大夫"]};
    }
    return _hospitalAndDoctorTitleMap;
}

- (NSArray *)collectionTypeTitles {
    if (_collectionTypeTitles == nil) {
        _collectionTypeTitles = @[@"心电图", @"血糖值"];
    }
    return _collectionTypeTitles;
}

- (NSArray *)collectionDeviceTitles {
    if (_collectionDeviceTitles == nil) {
        _collectionDeviceTitles = @[@"E100", @"F300"];
    }
    return _collectionDeviceTitles;
}















@end
