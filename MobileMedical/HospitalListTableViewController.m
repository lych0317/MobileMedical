//
//  HospitalListTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "HospitalListTableViewController.h"
#import "DoctorListTableViewController.h"
#import "Utils.h"
#import "ProtocolManager.h"
#import "HospitalModel.h"
#import "QueryHospitalResult.h"
#import "Config.h"

#define DoctorListSegue @"DoctorListSegue"

@interface HospitalListTableViewController ()

@property (nonatomic, strong) NSArray *hospitals;
@property (nonatomic, strong) NSArray *selectedHospitals;

@end

@implementation HospitalListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.selectedHospitals = [Config sharedConfig].hospitalDoctorMap.allKeys;
    if (self.hospitals.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.hospitals == nil || self.hospitals.count == 0) {
        [self fetchHospitalList];
    }
}

- (void)fetchHospitalList {
    [Utils showProgressViewTitle:@"正在请求医院列表"];
    [[ProtocolManager sharedManager] postQueryHospitalWithSuccess:^(id data) {
        [Utils hideProgressViewAfter:0];
        QueryHospitalResult *result = data;
        if ([result.return_code intValue] == 0) {
            self.hospitals = result.hospitals;
            [self.tableView reloadData];
        } else {
            [Utils showToastWithTitle:@"请求数据失败" time:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils hideProgressViewAfter:0];
        [Utils showToastWithTitle:@"请求数据失败" time:1];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSMutableString *doctorIds = [NSMutableString string];
    [[Config sharedConfig].hospitalDoctorMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *doctors = obj;
        [doctors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [doctorIds appendFormat:@"%@#%@,", key, obj];
        }];
    }];
    if ([Config sharedConfig].hospitalDoctorMap.count > 0) {
        [Config sharedConfig].doctorIds = [doctorIds substringToIndex:doctorIds.length - 1];
    } else {
        [Config sharedConfig].doctorIds = doctorIds;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hospitals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    HospitalModel *model = self.hospitals[indexPath.row];
    cell.textLabel.text = model.name;
    if ([self isContainedHospital:model.hospitalId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (BOOL)isContainedHospital:(NSString *)hospital {
    for (NSString *h in self.selectedHospitals) {
        if ([hospital isEqualToString:h]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:DoctorListSegue sender:self.hospitals[indexPath.row]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DoctorListSegue]) {
        DoctorListTableViewController *viewController = segue.destinationViewController;
        viewController.hospitalModel = sender;
    }
}

@end
