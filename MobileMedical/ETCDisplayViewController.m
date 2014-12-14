//
//  ETCDisplayViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/12/14.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "ETCDisplayViewController.h"
#import "ProtocolManager.h"
#import "ETCModel.h"
#import "ETCResult.h"
#import "OperatingStaff.h"
#import "StaffModel.h"
#import "Utils.h"
#import "Constants.h"

@interface ETCDisplayViewController ()

@property (nonatomic, strong) NSArray *etcModelArray;

@end

@implementation ETCDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchETCWithDate:[NSDate date]];
}

- (void)fetchETCWithDate:(NSDate *)date {
    [Utils showProgressViewTitle:@"正在请求数据"];
    [[ProtocolManager sharedManager] postQueryETC:date pId:self.operatingStaff.staffModel.pId success:^(id data) {
        [Utils hideProgressViewAfter:0];
        ETCResult *result = data;
        if ([result.return_code intValue] == 0) {
            self.etcModelArray = result.ecgs;
            [self displayData];
        } else if ([result.return_code intValue] == -1) {
            [Utils showToastWithTitle:@"这天没有任何数据" time:1];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils showToastWithTitle:@"请求数据失败" time:1];
        [Utils hideProgressViewAfter:0];
    }];
}

- (void)displayData {

}

#pragma mark - Calendar delegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    [super calendar:calendar didSelectDate:date];
    [self fetchETCWithDate:date];
}

@end
