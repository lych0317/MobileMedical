//
//  StaffListTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "StaffListTableViewController.h"
#import "ProtocolManager.h"
#import "StaffModel.h"
#import "QueryStaffListResult.h"
#import "OtherDataCollectViewController.h"
#import "DataTransferViewController.h"
#import "Config.h"
#import "Utils.h"

#define BloodSugarSegue @"BloodSugarSegue"
#define DataTransferSegue @"DataTransferSegue"
#define OtherDataCollectSegue @"OtherDataCollectSegue"

#define DataDisplaySegue @"DataDisplaySegue"

@interface StaffListTableViewController ()

@property (nonatomic, strong) NSArray *staffModels;

@end

@implementation StaffListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.staffModels == nil || self.staffModels.count == 0) {
        [self fetchStaffList];
    }
}

- (void)fetchStaffList {
    [Utils showProgressViewTitle:@"正在请求人员列表"];
    [[ProtocolManager sharedManager] postQueryStaffListWithSuccess:^(id data) {
        [Utils hideProgressViewAfter:0];
        QueryStaffListResult *result = data;
        if ([result.return_code intValue] == 0) {
            self.staffModels = result.patients;
            [self.tableView reloadData];
        } else {
            [Utils showToastWithTitle:@"请求数据失败" time:1];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils hideProgressViewAfter:0];
        [Utils showToastWithTitle:@"请求数据失败" time:1];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.staffModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    StaffModel *model =self.staffModels[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Config *config = [Config sharedConfig];
    StaffModel *staffModel = self.staffModels[indexPath.row];
    config.username = staffModel.username;
    config.password = staffModel.password;
    config.pId = staffModel.pId;
    config.name = staffModel.name;
    config.chengwei = staffModel.chengwei;
    config.phone = staffModel.phone;
    config.doctorIds = staffModel.doctorIds;
    config.paytype = staffModel.paytype;

    if (self.tabBarController.selectedIndex == 0) {
        [self performSegueWithIdentifier:DataDisplaySegue sender:nil];
    } else if (self.tabBarController.selectedIndex == 1) {
        if ([self.typeTitle isEqualToString:@"空腹血糖"] || [self.typeTitle isEqualToString:@"餐前血糖"] || [self.typeTitle isEqualToString:@"餐后2h血糖"] || [self.typeTitle isEqualToString:@"随机血糖"] || [self.typeTitle isEqualToString:@"心电仪"]) {
            [self performSegueWithIdentifier:DataTransferSegue sender:nil];
        } else {
            [self performSegueWithIdentifier:OtherDataCollectSegue sender:self.typeTitle];
        }
    }
//    [self performSegueWithIdentifier:StaffSegue sender:self.staffModels[indexPath.row]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:OtherDataCollectSegue]) {
        OtherDataCollectViewController *viewController = segue.destinationViewController;
        viewController.otherDataTitle = sender;
    }
}

@end
