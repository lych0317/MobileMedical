//
//  Utils.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)showToastWithTitle:(NSString *)title time:(NSTimeInterval)time {
    MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
    loading.mode = MBProgressHUDModeText;
    loading.labelText = title;
    [loading hide:YES afterDelay:time];
}

MBProgressHUD *_loading;

+ (void)showProgressViewTitle:(NSString *)title {
    _loading = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
    _loading.labelText = title;
}

+ (void)switchProgressViewTitle:(NSString *)title {
    _loading.labelText = title;
}

+ (void)hideProgressViewAfter:(NSTimeInterval)delay {
    [_loading hide:YES afterDelay:delay];
}

+ (void)hideProgressViewWithTitle:(NSString *)title after:(NSTimeInterval)delay {
    [Utils switchProgressViewTitle:title];
    [Utils hideProgressViewAfter:delay];
}

+ (void)hideProgressViewWithTitle:(NSString *)title after:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    _loading.completionBlock = completionBlock;
    [Utils hideProgressViewWithTitle:title after:delay];
}

+ (NSString *)stringDateFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringTimeFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:string];
}

+ (NSDate *)dateFromStringDate:(NSString *)date time:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    return [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", date, time]];
}

+ (void)saveToUserDefaultWithKey:(NSString *)key object:(id)data {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:data forKey:key];
    [userDefault synchronize];
}

+ (id)getObjectFromUserDefaultWithKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}

+ (void)removeObjectFromUserDefaultWithKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];
}

@end
