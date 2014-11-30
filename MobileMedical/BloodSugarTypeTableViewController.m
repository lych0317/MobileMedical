//
//  BloodSugarTypeTableViewController.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "BloodSugarTypeTableViewController.h"
#import "DataTransferTableViewController.h"
#import "StaffListTableViewController.h"
#import "OperatingStaff.h"
#import "BloodSugarModel.h"
#import "Config.h"
#import "AppModel.h"

#define DataTransferSegue @"DataTransferSegue"
#define StaffListSegue @"StaffListSegue"

@interface BloodSugarTypeTableViewController ()

@end

@implementation BloodSugarTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppModel sharedAppModel].bloodSugarTestTypeTitleMap.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [AppModel sharedAppModel].bloodSugarTestTypeTitleMap.allKeys[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.operatingStaff.bloodSugarTestType = [[AppModel sharedAppModel].bloodSugarTestTypeTitleMap.allValues[indexPath.row] intValue];
    if ([[Config sharedConfig].usertype intValue] == 1) {
        [self performSegueWithIdentifier:StaffListSegue sender:self.operatingStaff];
    } else if ([[Config sharedConfig].usertype intValue] == 2) {
        [self performSegueWithIdentifier:DataTransferSegue sender:self.operatingStaff];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DataTransferSegue]) {
        DataTransferTableViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    } else if ([segue.identifier isEqualToString:StaffListSegue]) {
        StaffListTableViewController *viewController = segue.destinationViewController;
        viewController.operatingStaff = sender;
    }
}

@end
