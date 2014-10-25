//
//  AppModel.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

@property (nonatomic, strong) NSArray *staffs;

@property (nonatomic, strong) NSArray *genderTitles;
@property (nonatomic, strong) NSArray *payTypeTitles;
@property (nonatomic, strong) NSDictionary *hospitalAndDoctorTitleMap;
@property (nonatomic, strong) NSArray *collectionTypeTitles;
@property (nonatomic, strong) NSArray *collectionDeviceTitles;

+ (instancetype)sharedAppModel;

@end
