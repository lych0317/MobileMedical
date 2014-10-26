//
//  Utils.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "Utils.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation Utils

+ (void)showToastWithTitle:(NSString *)title time:(NSTimeInterval)time {
    MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
    loading.mode = MBProgressHUDModeText;
    loading.labelText = title;
    [loading hide:YES afterDelay:time];
}

+ (NSString *)stringDateFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
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

@end
