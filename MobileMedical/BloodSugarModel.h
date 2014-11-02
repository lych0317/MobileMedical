//
//  BloodSugarModel.h
//  MobileMedical
//
//  Created by li yuanchao on 14/11/2.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodSugarModel : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSNumber *testType;
@property (nonatomic, strong) NSNumber *isSimpleTestModel;
@property (nonatomic, strong) NSNumber *style;
@property (nonatomic, strong) NSNumber *value;
// 这里用string类型是为了在查询数据库时方便比较选择性查询 格式：yyyy-MM-dd hh-mm-ss
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;

@end
