//
//  DisplaySelectedTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DisplaySelectedTableViewController.h"
#import "StaffModel.h"
#import "CollectionModel.h"

@interface DisplaySelectedTableViewController ()

@end

@implementation DisplaySelectedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.staffModel.collectionModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    CollectionModel *model = self.staffModel.collectionModels[indexPath.row];
    cell.textLabel.text = model.collectionType;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
