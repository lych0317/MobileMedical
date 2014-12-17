//
//  CollectionTypeTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "CollectionTypeTableViewController.h"
#import "OtherDataCollectViewController.h"
#import "StaffListTableViewController.h"
#import "BloodSugarTypeTableViewController.h"
#import "DataTransferTableViewController.h"
#import "OperatingStaff.h"
#import "AppModel.h"
#import "Config.h"

#define StaffListSegue @"StaffListSegue"
#define BloodSugarTypeSegue @"BloodSugarTypeSegue"
#define ETCTransferSegue @"ETCTransferSegue"
#define OtherDataCollectSegue @"OtherDataCollectSegue"

@interface CollectionTypeTableViewController ()

@property (nonatomic, strong) OperatingStaff *operatingStaff;

@end

@implementation CollectionTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.operatingStaff = [[OperatingStaff alloc] init];
    self.operatingStaff.operationType = OperationTypeCollection;
    self.clearsSelectionOnViewWillAppear = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [AppModel sharedAppModel].deviceTestTypeTitleMap.count;
    } else if (section == 1) {
        return [AppModel sharedAppModel].otherTestTypeTitleMap.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"医疗设备";
    } else if (section == 1) {
        return @"其他数据";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.textLabel.text = [AppModel sharedAppModel].deviceTestTypeTitleMap.allKeys[indexPath.row];
    } else {
        cell.textLabel.text = [AppModel sharedAppModel].otherTestTypeTitleMap.allKeys[indexPath.row];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.operatingStaff.testType = TestTypeDevice;
        self.operatingStaff.deviceTestType = [[AppModel sharedAppModel].deviceTestTypeTitleMap.allValues[indexPath.row] intValue];
        if ([[Config sharedConfig].usertype intValue] == 1) {
            if (self.operatingStaff.deviceTestType == DeviceTestTypeBloodSugar) {
                [self performSegueWithIdentifier:BloodSugarTypeSegue sender:self.operatingStaff];
            } else if (self.operatingStaff.deviceTestType == DeviceTestTypeETC) {
                [self performSegueWithIdentifier:StaffListSegue sender:self.operatingStaff];
            }
        } else if ([[Config sharedConfig].usertype intValue] == 2) {
            self.operatingStaff.staffModel = [Config sharedConfig].accountStaff;
            if (self.operatingStaff.deviceTestType == DeviceTestTypeBloodSugar) {
                [self performSegueWithIdentifier:BloodSugarTypeSegue sender:self.operatingStaff];
            } else if (self.operatingStaff.deviceTestType == DeviceTestTypeETC) {
                [self performSegueWithIdentifier:ETCTransferSegue sender:self.operatingStaff];
            }
        }
    } else if (indexPath.section == 1) {
        self.operatingStaff.testType = TestTypeOther;
        self.operatingStaff.otherTestType = [[AppModel sharedAppModel].otherTestTypeTitleMap.allValues[indexPath.row] intValue];
        if ([[Config sharedConfig].usertype intValue] == 1) {
            [self performSegueWithIdentifier:StaffListSegue sender:self.operatingStaff];
        } else if ([[Config sharedConfig].usertype intValue] == 2) {
            self.operatingStaff.staffModel = [Config sharedConfig].accountStaff;
            [self performSegueWithIdentifier:OtherDataCollectSegue sender:self.operatingStaff];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:OtherDataCollectSegue]) {
        OtherDataCollectViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    } else if ([segue.identifier isEqualToString:StaffListSegue]) {
        StaffListTableViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    } else if ([segue.identifier isEqualToString:BloodSugarTypeSegue]) {
        BloodSugarTypeTableViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    } else if ([segue.identifier isEqualToString:ETCTransferSegue]) {
        DataTransferTableViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    }
}

@end
