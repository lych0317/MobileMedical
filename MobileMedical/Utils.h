//
//  Utils.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface Utils : NSObject

+ (void)showToastWithTitle:(NSString *)title time:(NSTimeInterval)time;

+ (void)showProgressViewTitle:(NSString *)title;
+ (void)switchProgressViewTitle:(NSString *)title;
+ (void)hideProgressViewAfter:(NSTimeInterval)delay;
+ (void)hideProgressViewWithTitle:(NSString *)title after:(NSTimeInterval)delay;
+ (void)hideProgressViewWithTitle:(NSString *)title after:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

+ (BOOL)validatePhone:(NSString *)phone;
+ (BOOL)validatePId:(NSString *)pId;

+ (NSString *)stringDateFromDate:(NSDate *)date;
+ (NSString *)stringTimeFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromStringDate:(NSString *)date time:(NSString *)time;

+ (void)saveToUserDefaultWithKey:(NSString *)key object:(id)data;
+ (id)getObjectFromUserDefaultWithKey:(NSString *)key;
+ (void)removeObjectFromUserDefaultWithKey:(NSString *)key;

@end
