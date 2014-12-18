//
//  BloodSugarModel.h
//  MobileMedical
//
//  Created by li yuanchao on 14/11/2.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodSugarModel : NSObject

@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *pId;

@end
