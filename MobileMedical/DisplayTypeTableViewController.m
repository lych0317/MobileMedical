//
//  DisplayTypeTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DisplayTypeTableViewController.h"
#import "StaffListTableViewController.h"
#import "BloodSugarDisplayViewController.h"
#import "ETCDisplayViewController.h"
#import "AppModel.h"
#import "OperatingStaff.h"
#import "Constants.h"
#import "Config.h"

#define BloodSugarDisplaySegue @"BloodSugarDisplaySegue"
#define ETCDisplaySegue @"ETCDisplaySegue"
#define StaffListSegue @"StaffListSegue"

@interface DisplayTypeTableViewController ()

@property (nonatomic, strong) OperatingStaff *operatingStaff;

@end

@implementation DisplayTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.operatingStaff = [[OperatingStaff alloc] init];
    self.operatingStaff.operationType = OperationTypeDisplay;
    self.clearsSelectionOnViewWillAppear = YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppModel sharedAppModel].deviceTestTypeTitleMap.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [AppModel sharedAppModel].deviceTestTypeTitleMap.allKeys[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.operatingStaff.deviceTestType = [[AppModel sharedAppModel].deviceTestTypeTitleMap.allValues[indexPath.row] intValue];
    if ([[Config sharedConfig].usertype intValue] == 1) {
        [self performSegueWithIdentifier:StaffListSegue sender:self.operatingStaff];
    } else if ([[Config sharedConfig].usertype intValue] == 2) {
        self.operatingStaff.staffModel = [Config sharedConfig].accountStaff;
        if (self.operatingStaff.testType == TestTypeDevice) {
            if (self.operatingStaff.deviceTestType == DeviceTestTypeBloodSugar) {
                [self performSegueWithIdentifier:BloodSugarDisplaySegue sender:self.operatingStaff];
            } else if (self.operatingStaff.deviceTestType == DeviceTestTypeETC) {
                [self performSegueWithIdentifier:ETCDisplaySegue sender:self.operatingStaff];
            }
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:StaffListSegue]) {
        StaffListTableViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    } else if ([segue.identifier isEqualToString:BloodSugarDisplaySegue] || [segue.identifier isEqualToString:ETCDisplaySegue]) {
        DataDisplayViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    }
}

@end
