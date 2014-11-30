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

- (NSDictionary *)bloodSugarTestTypeTitleMap {
    if (_bloodSugarTestTypeTitleMap == nil) {
        _bloodSugarTestTypeTitleMap = @{@"空腹血糖": @(BloodSugarTestTypeEmptyStomach), @"餐前血糖": @(BloodSugarTestTypeBeforMeal), @"餐后2h血糖": @(BloodSugarTestTypeAfterMeal2h), @"随机血糖": @(BloodSugarTestTypeRandom)};
    }
    return _bloodSugarTestTypeTitleMap;
}

- (NSDictionary *)deviceTestTypeTitleMap {
    if (_deviceTestTypeTitleMap == nil) {
        _deviceTestTypeTitleMap = @{@"血糖仪": @(DeviceTestTypeBloodSugar), @"心电仪": @(DeviceTestTypeETC)};
    }
    return _deviceTestTypeTitleMap;
}

- (NSDictionary *)otherTestTypeTitleMap {
    if (_otherTestTypeTitleMap == nil) {
        _otherTestTypeTitleMap = @{@"膳食": @(OtherTestTypeDiet), @"运动量": @(OtherTestTypeSport), @"服药": @(OtherTestTypeMedicine), @"抽烟": @(OtherTestTypeSmoke), @"饮酒": @(OtherTestTypeDrink), @"精神状态": @(OtherTestTypeSpirit)};
    }
    return _otherTestTypeTitleMap;
}

- (NSDictionary *)spiritTypeTitleMap {
    if (_spiritTypeTitleMap == nil) {
        _spiritTypeTitleMap =@{@"无压力": @(SpiritTypeOne), @"轻微": @(SpiritTypeTwo), @"中等": @(SpiritTypeThree), @"严重": @(SpiritTypeFour), @"非常严重": @(SpiritTypeFive)};
    }
    return _spiritTypeTitleMap;
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
