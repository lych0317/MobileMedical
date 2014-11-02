//
//  CollectionSelectedTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/25.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "CollectionSelectedTableViewController.h"
#import "DataTransferViewController.h"
#import "BloodSugarTypeTableViewController.h"
#import "StaffModel.h"
#import "CollectionModel.h"
#import "ETCModel.h"
#import "BloodSugarModel.h"

#define BloodSugarSegue @"BloodSugarSegue"
#define DataTransferSegue @"DataTransferSegue"
#define OtherDataCollectSegue @"OtherDataCollectSegue"

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

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.staffModel.collectionModels.count) {
        [self performSegueWithIdentifier:OtherDataCollectSegue sender:nil];
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *collectionType = cell.textLabel.text;
        NSRange range = [collectionType rangeOfString:@"血糖"];
        if (range.length > 0) {
            [self performSegueWithIdentifier:BloodSugarSegue sender:[[BloodSugarModel alloc] init]];
        } else {
            [self performSegueWithIdentifier:DataTransferSegue sender:[[ETCModel alloc] init]];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DataTransferSegue]) {
        DataTransferViewController *viewController = segue.destinationViewController;
        viewController.etcModel = sender;
    } else if ([segue.identifier isEqualToString:BloodSugarSegue]) {
        BloodSugarTypeTableViewController *viewController = segue.destinationViewController;
        viewController.bloodSugarModel = sender;
    }
}

@end
