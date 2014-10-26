//
//  StaffManagerTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "StaffManagerTableViewController.h"
#import "StaffViewController.h"
#import "DatabaseManager.h"
#import "AppModel.h"
#import "StaffModel.h"

#define StaffSegue @"StaffSegue"

@interface StaffManagerTableViewController ()

@end

@implementation StaffManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightBarButtonItem];
}

- (void)addRightBarButtonItem {
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] init];
    addButtonItem.title = @"添加";
    addButtonItem.target = self;
    addButtonItem.action = @selector(addButtonItemClicked:);
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"人员管理";
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"取消";
}

#pragma mark - Selectors

- (void)addButtonItemClicked:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:StaffSegue sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppModel sharedAppModel].staffModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    StaffModel *model = [AppModel sharedAppModel].staffModels[indexPath.row];
    cell.textLabel.text = model.relation;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:StaffSegue sender:[AppModel sharedAppModel].staffModels[indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[DatabaseManager sharedManager] deleteStaff:[AppModel sharedAppModel].staffModels[indexPath.row]];
        [[AppModel sharedAppModel].staffModels removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:StaffSegue]) {
        StaffViewController *viewController = segue.destinationViewController;
        viewController.staffModel = sender;
    }
}

@end
