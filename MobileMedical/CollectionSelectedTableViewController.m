//
//  CollectionSelectedTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "CollectionSelectedTableViewController.h"
#import "StaffModel.h"
#import "CollectionModel.h"

@interface CollectionSelectedTableViewController ()

@end

@implementation CollectionSelectedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.staffModel.collectionModels.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    if (indexPath.row < self.staffModel.collectionModels.count) {
        CollectionModel *model = self.staffModel.collectionModels[indexPath.row];
        cell.textLabel.text = model.collectionType;
    } else {
        cell.textLabel.text = @"其他数据";
    }
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
