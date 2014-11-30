//
//  AppModel.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OtherDataModel;

@interface AppModel : NSObject

@property (nonatomic, strong) NSURL *baseUrl;

@property (nonatomic, strong) NSMutableArray *staffModels;
@property (nonatomic, strong) NSMutableArray *etcModels;
@property (nonatomic, strong) NSMutableArray *bloodSugarModels;
@property (nonatomic, strong) NSDictionary *bloodSugarTestTypeTitleMap;
@property (nonatomic, strong) NSDictionary *deviceTestTypeTitleMap;
@property (nonatomic, strong) NSDictionary *otherTestTypeTitleMap;
@property (nonatomic, strong) NSDictionary *spiritTypeTitleMap;

@property (nonatomic, strong) NSArray *genderTitles;
@property (nonatomic, strong) NSArray *payTypeTitles;
@property (nonatomic, strong) NSDictionary *hospitalAndDoctorTitleMap;
@property (nonatomic, strong) NSDictionary *collectionTypeAndDeviceTitleMap;
@property (nonatomic, strong) OtherDataModel *otherDataModel;

+ (instancetype)sharedAppModel;

@end
