//
//  PayTypeTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "PayTypeTableViewController.h"
#import "AppModel.h"
#import "Utils.h"
#import "Config.h"

@interface PayTypeTableViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation PayTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppModel sharedAppModel].payTypeTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [AppModel sharedAppModel].payTypeTitles[indexPath.row];
    if ((indexPath.row + 1) == [[Config sharedConfig].paytype intValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *oldSelectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
    oldSelectedCell.accessoryType = UITableViewCellAccessoryNone;

    UITableViewCell *newSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    newSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;

    [Config sharedConfig].paytype = @(indexPath.row + 1);
    self.selectedIndexPath = indexPath;

    [self.navigationController popViewControllerAnimated:YES];
}

@end
