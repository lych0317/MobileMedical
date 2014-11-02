//
//  BloodSugarTypeTableViewController.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "BloodSugarTypeTableViewController.h"
#import "DataTransferViewController.h"
#import "BloodSugarModel.h"

#define DataTransferSegue @"DataTransferSegue"

@interface BloodSugarTypeTableViewController ()

@property (nonatomic, strong) NSArray *bloodSugarTitles;

@end

@implementation BloodSugarTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bloodSugarTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.bloodSugarTitles[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.bloodSugarModel.testType = [NSNumber numberWithInt:indexPath.row];
    [self performSegueWithIdentifier:DataTransferSegue sender:self.bloodSugarModel];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DataTransferSegue]) {
        DataTransferViewController *viewController = segue.destinationViewController;
        viewController.bloodSugarModel = sender;
    }
}

#pragma mark - Getters

- (NSArray *)bloodSugarTitles {
    if (_bloodSugarTitles == nil) {
        _bloodSugarTitles = @[@"空腹血糖", @"餐前血糖", @"餐后2h血糖", @"随机血糖"];
    }
    return _bloodSugarTitles;
}

@end
