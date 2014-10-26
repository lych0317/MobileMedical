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

- (NSMutableArray *)staffModels {
    if (_staffModels == nil) {
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
        collection.collectionDevice = self.collectionTypeAndDeviceTitleMap.allValues[0][0];
        collection.collectionType = self.collectionTypeAndDeviceTitleMap.allKeys[0];
        model.collectionModels = @[collection];
        _staffModels = [NSMutableArray arrayWithObject:model];
    }
    return _staffModels;
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

- (NSDictionary *)collectionTypeAndDeviceTitleMap {
    if (_collectionTypeAndDeviceTitleMap == nil) {
        _collectionTypeAndDeviceTitleMap = @{@"心电图": @[@"E100", @"E200"], @"血糖值": @[@"F100", @"F200"]};
    }
    return _collectionTypeAndDeviceTitleMap;
}
//@property (nonatomic, strong) NSArray *diet;
//@property (nonatomic, strong) NSArray *sport;
//@property (nonatomic, strong) NSArray *medicine;
//@property (nonatomic, strong) NSArray *smoke;
//@property (nonatomic, strong) NSArray *drink;
//@property (nonatomic, strong) NSArray *spirit;
- (OtherDataModel *)otherDataModel {
    if (_otherDataModel == nil) {
        _otherDataModel = [[OtherDataModel alloc] init];
        _otherDataModel.diet = [NSMutableArray array];
        _otherDataModel.sport = [NSMutableArray array];
        _otherDataModel.medicine = [NSMutableArray array];
        _otherDataModel.smoke = [NSMutableArray array];
        _otherDataModel.drink = [NSMutableArray array];
        _otherDataModel.spirit = [NSMutableArray array];
    }
    return _otherDataModel;
}














@end
