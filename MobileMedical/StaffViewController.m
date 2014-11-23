//
//  StaffViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "StaffViewController.h"
#import "DatabaseManager.h"
#import "AppModel.h"
#import "StaffModel.h"
#import "Utils.h"
#import "Config.h"
#import "Constants.h"
#import "ProtocolManager.h"
#import "BaseResult.h"

#define HospitalListSegue @"HospitalListSegue"
#define PayTypeSegue @"PayTypeSegue"

@interface StaffViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *chengweiTextField;
@property (weak, nonatomic) IBOutlet UITextField *pIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *payTypeTextField;

@property (weak, nonatomic) IBOutlet UIButton *chooseDoctorButton;

@property (nonatomic, strong) UITextField *editingTextFiled;
@property (nonatomic, assign) BOOL isAdd;

@end

@implementation StaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightBarButtonItem];
    self.isAdd = NO;

    if (self.staffModel == nil) {
        self.staffModel = [[StaffModel alloc] init];
        self.isAdd = YES;
        self.usernameTextField.placeholder = @"用户名（必填）";
        self.passwordTextField.placeholder = @"密码（必填）";
    }

    [Config sharedConfig].username = self.staffModel.username;
    [Config sharedConfig].password = self.staffModel.password;
    [Config sharedConfig].name = self.staffModel.name;
    [Config sharedConfig].chengwei = self.staffModel.chengwei;
    [Config sharedConfig].pId = self.staffModel.pId;
    [Config sharedConfig].phone = self.staffModel.phone;
    [Config sharedConfig].doctorIds = self.staffModel.doctorIds;
    [Config sharedConfig].paytype = self.staffModel.paytype;
}

- (void)setupTextField {
    Config *config = [Config sharedConfig];
    self.usernameTextField.text = config.username;
    self.passwordTextField.text = config.password;
    self.nameTextField.text = config.name;
    self.chengweiTextField.text = config.chengwei;
    self.pIdTextField.text = config.pId;
    self.phoneTextField.text = config.phone;
    if (config.paytype) {
        int payType = [config.paytype intValue];
        if (payType > 0 && payType <= [AppModel sharedAppModel].payTypeTitles.count) {
            self.payTypeTextField.text = [AppModel sharedAppModel].payTypeTitles[payType - 1];
        }
    }
}

- (void)addRightBarButtonItem {
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] init];
    doneButtonItem.title = @"完成";
    doneButtonItem.target = self;
    doneButtonItem.action = @selector(doneButtonItemClicked:);
    self.navigationItem.rightBarButtonItem = doneButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupTextField];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:PayTypeSegue]) {

    }
}

#pragma mark - Selectors

- (void)doneButtonItemClicked:(UIBarButtonItem *)sender {
    if (self.isAdd) {
        NSString *username = self.usernameTextField.text;
        NSString *password = self.passwordTextField.text;
        NSString *pId = self.pIdTextField.text;
        NSString *doctorIds = [self getDoctorsIds];
        if (CHECK_STRING_NOT_NULL(username) && CHECK_STRING_NOT_NULL(password) && CHECK_STRING_NOT_NULL(pId) && CHECK_STRING_NOT_NULL(doctorIds)) {
            StaffModel *staffModel = [[StaffModel alloc] init];
            staffModel.pId = pId;
            staffModel.username = username;
            staffModel.password = password;
            staffModel.name = self.nameTextField.text;
            staffModel.chengwei = self.chengweiTextField.text;
            staffModel.phone = self.phoneTextField.text;
            staffModel.doctorIds = doctorIds;
            staffModel.paytype = [Config sharedConfig].paytype;
            staffModel.opr = @(1);
            [self postStaff:staffModel];
        } else {
            [Utils showToastWithTitle:@"请输入必填项" time:1];
        }
    } else {
        NSString *pId = self.pIdTextField.text;
        NSString *doctorIds = [self getDoctorsIds];
        if (CHECK_STRING_NOT_NULL(pId) && CHECK_STRING_NOT_NULL(doctorIds)) {
            StaffModel *staffModel = [[StaffModel alloc] init];
            staffModel.pId = pId;
            staffModel.username = self.usernameTextField.text;
            staffModel.password = self.passwordTextField.text;
            staffModel.name = self.nameTextField.text;
            staffModel.chengwei = self.chengweiTextField.text;
            staffModel.phone = self.phoneTextField.text;
            staffModel.doctorIds = doctorIds;
            staffModel.paytype = [Config sharedConfig].paytype;
            staffModel.opr = @(2);
            [self postStaff:staffModel];
        } else {
            [Utils showToastWithTitle:@"请输入必填项" time:1];
        }
    }
}

- (NSString *)getDoctorsIds {
    NSMutableString *doctorsIds = [NSMutableString string];
    [[Config sharedConfig].hospitalDoctorMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *doctors = obj;
        [doctors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [doctorsIds appendFormat:@"%@,", obj];
        }];
    }];
    if (doctorsIds.length > 0) {
        return [doctorsIds substringToIndex:doctorsIds.length - 1];
    }
    return doctorsIds;
}

- (void)postStaff:(StaffModel *)staffModel {
    [Utils showProgressViewTitle:@"正在提交数据"];
    [[ProtocolManager sharedManager] postStaffWithStaffModel:staffModel success:^(id data) {
        [Utils hideProgressViewAfter:0];
        BaseResult *result = data;
        if (result) {
            if ([result.return_code intValue] == 0) {
                [Utils showToastWithTitle:@"提交数据成功" time:1];
                [self.navigationController popViewControllerAnimated:YES];
            } else if ([result.return_code intValue] == 4) {
                [Utils showToastWithTitle:@"身份证已经注册" time:1];
            } else if ([result.return_code intValue] == 401) {
                [Utils showToastWithTitle:@"身份证校验出错" time:1];
            } else if ([result.return_code intValue] == 402) {
                [Utils showToastWithTitle:@"密码校验出错" time:1];
            } else {
                [Utils showToastWithTitle:@"提交数据失败" time:1];
            }
        } else {
            [Utils showToastWithTitle:@"提交数据失败" time:1];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils hideProgressViewAfter:0];
        [Utils showToastWithTitle:@"提交数据失败" time:1];
    }];
}

- (IBAction)chooseDoctorButtonClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:HospitalListSegue sender:nil];
}
#pragma mark - Text field view delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.contentScrollView setContentOffset:CGPointMake(0, CGRectGetMinY(textField.frame) - 30) animated:YES];
    if (self.payTypeTextField == textField) {
        [self.editingTextFiled resignFirstResponder];
        [self performSegueWithIdentifier:PayTypeSegue sender:nil];
        return NO;
    }
    self.editingTextFiled = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [Config sharedConfig].username = self.usernameTextField.text;
    } else if (textField == self.passwordTextField) {
        [Config sharedConfig].password = self.passwordTextField.text;
    } else if (textField == self.nameTextField) {
        [Config sharedConfig].name = self.nameTextField.text;
    } else if (textField == self.chengweiTextField) {
        [Config sharedConfig].chengwei = self.chengweiTextField.text;
    } else if (textField == self.phoneTextField) {
        [Config sharedConfig].phone = self.phoneTextField.text;
    } else if (textField == self.pIdTextField) {
        [Config sharedConfig].pId = self.pIdTextField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.contentScrollView setContentOffset:CGPointZero];
    [textField resignFirstResponder];
    return YES;
}

@end
