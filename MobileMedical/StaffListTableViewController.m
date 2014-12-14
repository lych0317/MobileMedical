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
#import "BloodSugarDisplayViewController.h"
#import "ETCDisplayViewController.h"
#import "OperatingStaff.h"
#import "Config.h"
#import "Utils.h"
#import "Constants.h"

#define DataTransferSegue @"DataTransferSegue"
#define OtherDataCollectSegue @"OtherDataCollectSegue"

#define BloodSugarDisplaySegue @"BloodSugarDisplaySegue"
#define ETCDisplaySegue @"ETCDisplaySegue"

@interface StaffListTableViewController ()

@property (nonatomic, strong) NSArray *staffModels;

@end

@implementation StaffListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
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
    self.operatingStaff.staffModel = self.staffModels[indexPath.row];

    if (self.operatingStaff.operationType == OperationTypeDisplay) {
        if (self.operatingStaff.testType == TestTypeDevice) {
            if (self.operatingStaff.deviceTestType == DeviceTestTypeBloodSugar) {
                [self performSegueWithIdentifier:BloodSugarDisplaySegue sender:self.operatingStaff];
            } else if (self.operatingStaff.deviceTestType == DeviceTestTypeETC) {
                [self performSegueWithIdentifier:ETCDisplaySegue sender:self.operatingStaff];
            }
        }
    } else if (self.operatingStaff.operationType == OperationTypeCollection) {
        if (self.operatingStaff.testType == TestTypeDevice) {
            [self performSegueWithIdentifier:DataTransferSegue sender:self.operatingStaff];
        } else if (self.operatingStaff.testType == TestTypeOther) {
            [self performSegueWithIdentifier:OtherDataCollectSegue sender:self.operatingStaff];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:OtherDataCollectSegue]) {
        OtherDataCollectViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    } else if ([segue.identifier isEqualToString:DataTransferSegue]) {
        DataTransferViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    } else if ([segue.identifier isEqualToString:BloodSugarDisplaySegue] || [segue.identifier isEqualToString:ETCDisplaySegue]) {
        DataDisplayViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    }
}

@end
