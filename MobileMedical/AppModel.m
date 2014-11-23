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
#import "OtherDataModel.h"
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

- (NSURL *)baseUrl {
    if (_baseUrl == nil) {
        _baseUrl = [NSURL URLWithString:BASE_URL];
    }
    return _baseUrl;
}

- (NSArray *)deviceTypeTitles {
    if (_deviceTypeTitles == nil) {
        _deviceTypeTitles = @[@"血糖仪", @"心电仪"];
    }
    return _deviceTypeTitles;
}

- (NSArray *)otherDataTitles {
    if (_otherDataTitles == nil) {
        _otherDataTitles = @[@"膳食", @"运动量", @"服药", @"抽烟", @"饮酒", @"精神状态"];
    }
    return _otherDataTitles;
}

- (NSArray *)spiritTitles {
    if (_spiritTitles == nil) {
        _spiritTitles = @[@"无压力", @"轻微", @"中等", @"严重", @"非常严重"];
    }
    return _spiritTitles;
}

- (NSArray *)genderTitles {
    if (_genderTitles == nil) {
        _genderTitles = @[@"男", @"女"];
    }
    return _genderTitles;
}

- (NSArray *)payTypeTitles {
    if (_payTypeTitles == nil) {
        _payTypeTitles = @[@"支付宝", @"其他"];
    }
    return _payTypeTitles;
}

- (NSDictionary *)hospitalAndDoctorTitleMap {
    if (_hospitalAndDoctorTitleMap == nil) {
        _hospitalAndDoctorTitleMap = @{@"北京肛肠医院": @[@"张大夫", @"马大夫", @"王大夫"], @"北京301医院": @[@"张大夫", @"马大夫", @"王大夫"], @"北京天坛医院": @[@"张大夫", @"马大夫", @"王大夫"]};
    }
    return _hospitalAndDoctorTitleMap;
}

- (NSDictionary *)collectionTypeAndDeviceTitleMap {
    if (_collectionTypeAndDeviceTitleMap == nil) {
        _collectionTypeAndDeviceTitleMap = @{@"心电图": @[@"E100", @"E200"], @"血糖值": @[@"F100", @"F200"]};
    }
    return _collectionTypeAndDeviceTitleMap;
}













@end
