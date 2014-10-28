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
@property (weak, nonatomic) IBOutlet UIButton *comeToTadayButton;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *exceptionDataLabel;
@property (weak, nonatomic) IBOutlet UIView *dataDisplayView;

@end

@implementation DataDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendarView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.calendarView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.calendarView removeObserver:self forKeyPath:@"frame"];
    [super viewWillDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        [self layoutSubViews];
    }
}

- (void)layoutSubViews {
    float originY = (CGRectGetHeight(self.calendarView.frame) - 4 * CGRectGetHeight(self.comeToTadayButton.frame)) / 5;

    self.comeToTadayButton.center = CGPointMake(self.comeToTadayButton.center.x, CGRectGetMinY(self.calendarView.frame) + originY + CGRectGetHeight(self.comeToTadayButton.frame) / 2);

    self.noDataLabel.center = CGPointMake(self.noDataLabel.center.x, CGRectGetMaxY(self.comeToTadayButton.frame) + originY + CGRectGetHeight(self.noDataLabel.frame) / 2);

    self.normalDataLabel.center = CGPointMake(self.normalDataLabel.center.x, CGRectGetMaxY(self.noDataLabel.frame) + originY + CGRectGetHeight(self.normalDataLabel.frame) / 2);

    self.exceptionDataLabel.center = CGPointMake(self.exceptionDataLabel.center.x, CGRectGetMaxY(self.normalDataLabel.frame) + originY + CGRectGetHeight(self.exceptionDataLabel.frame) / 2);

    self.dataDisplayView.frame = CGRectMake(0, CGRectGetMaxY(self.calendarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.calendarView.frame));
}

#pragma mark - Selectors

- (IBAction)comeToTaday:(UIButton *)sender {
    [self.calendarView selectDate:[NSDate date] makeVisible:YES];
}

#pragma mark - Calendar delegate

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {

}

@end
