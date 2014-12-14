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

@end

@implementation DataDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightBarButtonItem];
    [self.view addSubview:self.calendarView];
}

- (void)addRightBarButtonItem {
    UIBarButtonItem *calendarButtonItem = [[UIBarButtonItem alloc] init];
    calendarButtonItem.title = @"日历";
    calendarButtonItem.target = self;
    calendarButtonItem.action = @selector(calendarButtonItemClicked:);
    self.navigationItem.rightBarButtonItem = calendarButtonItem;
}

- (void)calendarButtonItemClicked:(UIBarButtonItem *)sender {
    self.calendarView.hidden = !self.calendarView.hidden;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.calendarView.hidden = YES;
    self.calendarView.frame = CGRectMake(0, 68, CGRectGetWidth(self.view.frame), 0);
}

#pragma mark - Getters

- (CKCalendarView *)calendarView {
    if (_calendarView == nil) {
        _calendarView = [[CKCalendarView alloc] initWithStartDay:startSunday frame:CGRectZero];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

#pragma mark - Selectors

#pragma mark - Calendar delegate

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.calendarView.hidden = YES;
}

@end
