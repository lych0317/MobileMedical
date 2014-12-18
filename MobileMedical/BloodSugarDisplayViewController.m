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
#import "BloodSugarDisplayTableViewCell.h"
#import "Utils.h"
#import "Constants.h"

@interface BloodSugarDisplayViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSArray *bloodSugarModelArray;
@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation BloodSugarDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listTableView];
    [self.view sendSubviewToBack:self.listTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.listTableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [self fetchBloodSugarWithDate:[formatter dateFromString:[formatter stringFromDate:date]]];
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
            [self emptyBloodSugarData];
        } else {
            [self emptyBloodSugarData];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils showToastWithTitle:@"请求数据失败" time:1];
        [Utils hideProgressViewAfter:0];
        [self emptyBloodSugarData];
    }];
}

- (void)emptyBloodSugarData {
    self.bloodSugarModelArray = nil;
    [self.listTableView reloadData];
}

- (void)displayData {
    [self.listTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.bloodSugarModelArray) {
        return self.bloodSugarModelArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    BloodSugarDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = (BloodSugarDisplayTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"BloodSugarDisplayTableViewCell" owner:self options:nil]  lastObject];
    }
    cell.bloodSugarModel = self.bloodSugarModelArray[indexPath.row];
    return cell;
}

#pragma mark - Calendar delegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSDate *selectedDate;
    if (date == nil) {
        if (self.selectedDate == nil) {
            selectedDate = [NSDate date];
        } else {
            selectedDate = self.selectedDate;
        }
    } else {
        selectedDate = date;
    }
    [super calendar:calendar didSelectDate:date];
    [self fetchBloodSugarWithDate:selectedDate];
}

- (UITableView *)listTableView {
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.dataSource = self;
        _listTableView.allowsSelection = NO;
    }
    return _listTableView;
}

@end
