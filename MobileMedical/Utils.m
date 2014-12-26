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

+ (BOOL)validatePhone:(NSString *)phone {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+ (BOOL)validatePId:(NSString *)pId {
    if (pId.length == 15 || pId.length == 18) {
        NSString *emailRegex = @"^[0-9]*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[pId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

        if (pId.length == 15) {
            if (!sfzNo) {
                return NO;
            }
        }
        else if (pId.length == 18) {
            bool sfz18NO = [self checkIdentityCardNo:pId];
            if (!sfz18NO) {
                return NO;
            }
        }
    } else {
        return NO;
    }
    return YES;
}

+ (BOOL)checkIdentityCardNo:(NSString *)cardNo {
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];

    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];

    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;

    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }

    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];

    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
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
