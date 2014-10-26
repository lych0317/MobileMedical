//
//  Utils.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void)showToastWithTitle:(NSString *)title time:(NSTimeInterval)time;

+ (NSString *)stringDateFromDate:(NSDate *)date;

+ (NSString *)stringTimeFromDate:(NSDate *)date;

+ (NSDate *)dateFromString:(NSString *)string;

+ (NSDate *)dateFromStringDate:(NSString *)date time:(NSString *)time;

@end
