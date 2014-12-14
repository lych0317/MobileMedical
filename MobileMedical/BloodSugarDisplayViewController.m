//
//  BloodSugarDisplayViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/12/14.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "BloodSugarDisplayViewController.h"
#import "ProtocolManager.h"
#import "BloodSugarModel.h"
#import "BloodSugarResult.h"
#import "OperatingStaff.h"
#import "StaffModel.h"
#import "Utils.h"
#import "Constants.h"

@interface BloodSugarDisplayViewController ()

@property (nonatomic, strong) NSArray *bloodSugarModelArray;

@end

@implementation BloodSugarDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchBloodSugarWithDate:[NSDate date]];
}

- (void)fetchBloodSugarWithDate:(NSDate *)date {
    [Utils showProgressViewTitle:@"正在请求数据"];
    [[ProtocolManager sharedManager] postQueryBloodSugar:date pId:self.operatingStaff.staffModel.pId success:^(id data) {
        [Utils hideProgressViewAfter:0];
        BloodSugarResult *result = data;
        if ([result.return_code intValue] == 0) {
            self.bloodSugarModelArray = result.sugars;
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
    [self fetchBloodSugarWithDate:date];
}

@end
