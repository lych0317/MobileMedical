//
//  ETCDisplayViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/12/14.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "ETCDisplayViewController.h"
#import "ETCDisplayTableViewCell.h"
#import "ProtocolManager.h"
#import "ETCModel.h"
#import "ETCResult.h"
#import "OperatingStaff.h"
#import "StaffModel.h"
#import "Utils.h"
#import "Constants.h"

@interface ETCDisplayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *etcModelArray;
@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation ETCDisplayViewController

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
    [self fetchETCWithDate:[formatter dateFromString:[formatter stringFromDate:date]]];
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
    self.etcModelArray = nil;
    [self.listTableView reloadData];
}

- (void)displayData {
    [self.listTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.etcModelArray) {
        return self.etcModelArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    ETCDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = (ETCDisplayTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ETCDisplayTableViewCell" owner:self options:nil]  lastObject];
    }
    cell.etcModel = self.etcModelArray[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

#pragma mark - Calendar delegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    [super calendar:calendar didSelectDate:date];
    [self fetchETCWithDate:self.selectedDate];
}

- (UITableView *)listTableView {
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.allowsSelection = NO;
    }
    return _listTableView;
}

@end
