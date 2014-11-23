//
//  DataCollectTableViewController.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DataCollectTableViewController.h"
#import "AppModel.h"
#import "StaffModel.h"
//#import "CollectionSelectedTableViewController.h"

#define CollectionSelectedSegue @"CollectionSelectedSegue"

@interface DataCollectTableViewController ()

@end

@implementation DataCollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppModel sharedAppModel].staffModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    StaffModel *staffModel = [AppModel sharedAppModel].staffModels[indexPath.row];
//    cell.textLabel.text = staffModel.relation;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:CollectionSelectedSegue sender:[AppModel sharedAppModel].staffModels[indexPath.row]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:CollectionSelectedSegue]) {
//        CollectionSelectedTableViewController *viewController = segue.destinationViewController;
//        viewController.staffModel = sender;
    }
}

@end
