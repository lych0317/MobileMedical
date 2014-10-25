//
//  StaffManagerTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "StaffManagerTableViewController.h"
#import "StaffViewController.h"
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
    return [AppModel sharedAppModel].staffs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    StaffModel *model = [AppModel sharedAppModel].staffs[indexPath.row];
    cell.textLabel.text = model.relation;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:StaffSegue sender:[AppModel sharedAppModel].staffs[indexPath.row]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:StaffSegue]) {
        StaffViewController *viewController = segue.destinationViewController;
        viewController.staffModel = sender;
    }
}

@end
