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
#import "AppModel.h"
#import "Config.h"

#define StaffListSegue @"StaffListSegue"
#define BloodSugarSegue @"BloodSugarSegue"
#define DataTransferSegue @"DataTransferSegue"
#define OtherDataCollectSegue @"OtherDataCollectSegue"

@interface CollectionTypeTableViewController ()

@end

@implementation CollectionTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [AppModel sharedAppModel].deviceTypeTitles.count;
    } else if (section == 1) {
        return [AppModel sharedAppModel].otherDataTitles.count;
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
        cell.textLabel.text = [AppModel sharedAppModel].deviceTypeTitles[indexPath.row];
    } else {
        cell.textLabel.text = [AppModel sharedAppModel].otherDataTitles[indexPath.row];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([[Config sharedConfig].usertype intValue] == 1) {
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:BloodSugarSegue sender:nil];
            } else if (indexPath.row == 1) {
                [self performSegueWithIdentifier:StaffListSegue sender:@"心电仪"];
            }
        } else if ([[Config sharedConfig].usertype intValue] == 2) {
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:BloodSugarSegue sender:nil];
            } else if (indexPath.row == 1) {
                [self performSegueWithIdentifier:DataTransferSegue sender:nil];
            }
        }
    } else if (indexPath.section == 1) {
        if ([[Config sharedConfig].usertype intValue] == 1) {
            [self performSegueWithIdentifier:StaffListSegue sender:[AppModel sharedAppModel].otherDataTitles[indexPath.row]];
        } else if ([[Config sharedConfig].usertype intValue] == 2) {
            [self performSegueWithIdentifier:OtherDataCollectSegue sender:[AppModel sharedAppModel].otherDataTitles[indexPath.row]];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:OtherDataCollectSegue]) {
        OtherDataCollectViewController *viewController = segue.destinationViewController;
        viewController.otherDataTitle = sender;
    } else if ([segue.identifier isEqualToString:StaffListSegue]) {
        StaffListTableViewController *viewController = segue.destinationViewController;
        viewController.typeTitle = sender;
    }
}

@end
