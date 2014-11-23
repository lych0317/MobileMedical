//
//  DoctorListTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "DoctorListTableViewController.h"
#import "ProtocolManager.h"
#import "DoctorModel.h"
#import "QueryDoctorResult.h"
#import "HospitalModel.h"
#import "Utils.h"
#import "Config.h"

@interface DoctorListTableViewController ()

@property (nonatomic, strong) NSArray *doctors;
@property (nonatomic, strong) NSMutableArray *selectedDoctors;

@end

@implementation DoctorListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.selectedDoctors = [Config sharedConfig].hospitalDoctorMap[self.hospitalModel.hospitalId];
    if (self.selectedDoctors == nil) {
        self.selectedDoctors = [NSMutableArray array];
    }
    if (self.selectedDoctors.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchDoctorList];
}

- (void)fetchDoctorList {
    [Utils showProgressViewTitle:@"正在请求医生列表"];
    [[ProtocolManager sharedManager] postQueryDoctorWithHospital:self.hospitalModel success:^(id data) {
        [Utils hideProgressViewAfter:0];
        QueryDoctorResult *result = data;
        if ([result.return_code intValue] == 0) {
            self.doctors = result.doctors;
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
    NSMutableDictionary *hospitalDoctorMap = [NSMutableDictionary dictionaryWithDictionary:[Config sharedConfig].hospitalDoctorMap];
    if (self.selectedDoctors.count > 0) {
        [hospitalDoctorMap setObject:self.selectedDoctors forKey:self.hospitalModel.hospitalId];
    } else {
        [hospitalDoctorMap removeObjectForKey:self.hospitalModel.hospitalId];
    }
    [Config sharedConfig].hospitalDoctorMap = hospitalDoctorMap;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.doctors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    DoctorModel *model = self.doctors[indexPath.row];
    cell.textLabel.text = model.name;
    if ([self isContainedDoctor:model.doctorId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (BOOL)isContainedDoctor:(NSString *)doctor {
    for (NSString *d in self.selectedDoctors) {
        if ([doctor isEqualToString:d]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DoctorModel *model = self.doctors[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedDoctors removeObject:model.doctorId];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedDoctors addObject:model.doctorId];
    }
}

@end
