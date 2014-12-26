//
//  HospitalListTableViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "HospitalListTableViewController.h"
#import "DoctorListTableViewController.h"
#import "StaffModel.h"
#import "Utils.h"
#import "ProtocolManager.h"
#import "HospitalModel.h"
#import "QueryHospitalResult.h"
#import "Config.h"
#import "Constants.h"

#define DoctorListSegue @"DoctorListSegue"

@interface HospitalListTableViewController ()

@property (nonatomic, strong) NSArray *hospitals;
@property (nonatomic, strong) HospitalModel *tempHospitalModel;
@property (nonatomic, strong) NSArray *selectedHospitals;

@end

@implementation HospitalListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addRightBarButtonItem];
}

- (void)addRightBarButtonItem {
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] init];
    addButtonItem.title = @"提交";
    addButtonItem.target = self;
    addButtonItem.action = @selector(addButtonItemClicked:);
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)addButtonItemClicked:(UIBarButtonItem *)sender {
    if (CHECK_STRING_NOT_NULL(self.staffModel.username) && CHECK_STRING_NOT_NULL(self.staffModel.pId) && CHECK_STRING_NOT_NULL(self.staffModel.doctorIds) && CHECK_STRING_NOT_NULL(self.staffModel.phone)) {
        if (![Utils validatePId:self.staffModel.pId]) {
            [Utils showToastWithTitle:@"请输入正确的身份证号" time:1];
        } else if (![Utils validatePhone:self.staffModel.phone]) {
            [Utils showToastWithTitle:@"请输入正确的手机号" time:1];
        } else {
            [self updateStaff:self.staffModel];
        }
    } else {
        [Utils showToastWithTitle:@"请输入必填项" time:1];
    }
}

- (void)updateStaff:(StaffModel *)staffModel {
    [Utils showProgressViewTitle:@"正在提交数据"];
    StaffModel *model = [[StaffModel alloc] init];
    model.username = staffModel.username;
    model.password = staffModel.password;
    model.pId = staffModel.pId;
    model.name = staffModel.name;
    model.chengwei = staffModel.chengwei;
    model.phone = staffModel.phone;
    model.paytype = staffModel.paytype;
    model.opr = staffModel.opr;
    NSArray *doctorIds = [staffModel.doctorIds componentsSeparatedByString:@","];
    NSMutableString *doctorIdStr = [NSMutableString string];
    for (NSString *str in doctorIds) {
        NSArray *array = [str componentsSeparatedByString:@"#"];
        [doctorIdStr appendFormat:@"%@,", array[1]];
    }
    model.doctorIds = @"";
    if (doctorIdStr.length > 0) {
        model.doctorIds = [doctorIdStr substringToIndex:doctorIdStr.length - 1];
    }
    [[ProtocolManager sharedManager] postStaffWithStaffModel:model success:^(id data) {
        [Utils hideProgressViewAfter:0];
        BaseResult *result = data;
        if ([result.return_code intValue] == 0) {
            [Utils showToastWithTitle:@"提交数据成功" time:1];
            [Config sharedConfig].accountStaff = staffModel;
        } else {
            [Utils showToastWithTitle:@"提交数据失败" time:1];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils hideProgressViewAfter:0];
        [Utils showToastWithTitle:@"提交数据失败" time:1];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tempHospitalModel) {
        NSMutableDictionary *hospitalDoctorMap = [NSMutableDictionary dictionary];
        [hospitalDoctorMap setObject:self.tempHospitalModel.selectedDoctorIds forKey:self.tempHospitalModel.hospitalId];
        [self.staffModel.hospitalDoctorMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *hospitalId = key;
            if (![hospitalId isEqualToString:self.tempHospitalModel.hospitalId]) {
                [hospitalDoctorMap setObject:obj forKey:key];
            }
        }];
        [hospitalDoctorMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSArray *doctors = obj;
            if (doctors.count == 0) {
                [hospitalDoctorMap removeObjectForKey:key];
            }
        }];
        self.staffModel.hospitalDoctorMap = hospitalDoctorMap;
    }
    self.selectedHospitals = self.staffModel.hospitalDoctorMap.allKeys;
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
    [self.staffModel.hospitalDoctorMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *doctors = obj;
        [doctors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [doctorIds appendFormat:@"%@#%@,", key, obj];
        }];
    }];
    if (self.staffModel.hospitalDoctorMap.count > 0) {
        if (doctorIds.length > 0) {
            self.staffModel.doctorIds = [doctorIds substringToIndex:doctorIds.length - 1];
        }
    } else {
        self.staffModel.doctorIds = doctorIds;
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
        model.selectedDoctorIds = self.staffModel.hospitalDoctorMap[model.hospitalId];
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
    self.tempHospitalModel = self.hospitals[indexPath.row];
    [self performSegueWithIdentifier:DoctorListSegue sender:@{@"HospitalModel": self.tempHospitalModel, @"StaffModel": self.staffModel}];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DoctorListSegue]) {
        DoctorListTableViewController *viewController = segue.destinationViewController;
        viewController.dataMap = sender;
    }
}

@end
