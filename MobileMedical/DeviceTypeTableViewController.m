//
//  DeviceTypeTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DeviceTypeTableViewController.h"
#import "AppModel.h"
#import "Config.h"

#define DataDisplaySegue @"DataDisplaySegue"
#define StaffListSegue @"StaffListSegue"

@interface DeviceTypeTableViewController ()

@end

@implementation DeviceTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppModel sharedAppModel].deviceTypeTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [AppModel sharedAppModel].deviceTypeTitles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[Config sharedConfig].usertype intValue] == 1) {
        [self performSegueWithIdentifier:StaffListSegue sender:nil];
    } else if ([[Config sharedConfig].usertype intValue] == 2) {
        [self performSegueWithIdentifier:DataDisplaySegue sender:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
