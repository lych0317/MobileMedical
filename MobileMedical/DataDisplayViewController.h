//
//  DataDisplayViewController.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-28.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OperatingStaff, CKCalendarView;

@interface DataDisplayViewController : UIViewController

@property (strong, nonatomic) CKCalendarView *calendarView;
@property (nonatomic, strong) OperatingStaff *operatingStaff;

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date;

@end
