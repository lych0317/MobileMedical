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

@end
