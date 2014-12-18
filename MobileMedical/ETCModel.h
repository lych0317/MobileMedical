//
//  ETCModel.h
//  MobileMedical
//
//  Created by li yuanchao on 14/11/1.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETCModel : NSObject

@property (nonatomic, strong) NSNumber *pulse;
@property (nonatomic, strong) NSString *ecg;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *pId;

@end
