//
//  AppModel.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "AppModel.h"
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

- (NSArray *)appSettingTitles {
    if (_appSettingTitles == nil) {
        _appSettingTitles = @[AppSetting_Add, AppSetting_Delete, AppSetting_Update, AppSetting_More];
    }
    return _appSettingTitles;
}

@end
