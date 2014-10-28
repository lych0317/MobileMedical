//
//  DataDisplayViewController.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-28.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DataDisplayViewController.h"
#import <CKCalendar/CKCalendarView.h>

@interface DataDisplayViewController () <CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet CKCalendarView *calendarView;

@end

@implementation DataDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendarView.delegate = self;
}

#pragma mark - Calendar delegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {

}

@end
