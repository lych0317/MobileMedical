//
//  StaffViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "StaffViewController.h"
#import "HospitalListTableViewController.h"
#import "PayTypeTableViewController.h"
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
@property (weak, nonatomic) IBOutlet UITextView *doctorsTextView;

@property (weak, nonatomic) IBOutlet UIButton *chooseDoctorButton;

@property (nonatomic, strong) UITextField *editingTextFiled;
@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic, strong) StaffModel *tempStaffModel;

@end

@implementation StaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addRightBarButtonItem];
    self.isAdd = NO;

    if (self.staffModel == nil) {
        self.staffModel = [[StaffModel alloc] init];
        self.isAdd = YES;
        self.usernameTextField.placeholder = @"用户名（必填）";
        self.passwordTextField.placeholder = @"密码（必填）";
    }

    StaffModel *staffModel = [[StaffModel alloc] init];
    staffModel.username = self.staffModel.username;
    staffModel.password = self.staffModel.password;
    staffModel.pId = self.staffModel.pId;
    staffModel.name = self.staffModel.name;
    staffModel.chengwei = self.staffModel.chengwei;
    staffModel.phone = self.staffModel.phone;
    staffModel.doctorIds = self.staffModel.doctorIds;
    staffModel.paytype = self.staffModel.paytype;
    staffModel.opr = self.staffModel.opr;
    staffModel.doctors = self.staffModel.doctors;

    self.tempStaffModel = staffModel;
}

- (void)setupTextField {
    self.usernameTextField.text = self.tempStaffModel.username;
    self.passwordTextField.text = self.tempStaffModel.password;
    self.nameTextField.text = self.tempStaffModel.name;
    self.chengweiTextField.text = self.tempStaffModel.chengwei;
    self.pIdTextField.text = self.tempStaffModel.pId;
    self.phoneTextField.text = self.tempStaffModel.phone;
    self.doctorsTextView.text = [NSString stringWithFormat:@"责任医生：%@", self.tempStaffModel.doctors];
    if (self.tempStaffModel.paytype) {
        int payType = [self.tempStaffModel.paytype intValue];
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
    self.chooseDoctorButton.hidden = YES;
    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    self.nameTextField.enabled = NO;
    self.chengweiTextField.enabled = NO;
    self.pIdTextField.enabled = NO;
    self.phoneTextField.enabled = NO;
    self.payTypeTextField.enabled = NO;
    self.doctorsTextView.editable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:HospitalListSegue]) {
        HospitalListTableViewController *viewController = segue.destinationViewController;
        viewController.staffModel = sender;
    } else if ([segue.identifier isEqualToString:PayTypeSegue]) {
        PayTypeTableViewController *viewController = segue.destinationViewController;
        viewController.staffModel = sender;
    }
}

#pragma mark - Selectors

- (void)doneButtonItemClicked:(UIBarButtonItem *)sender {
    BOOL willPostData = NO;
    if (self.isAdd) {
        if (CHECK_STRING_NOT_NULL(self.tempStaffModel.username) && CHECK_STRING_NOT_NULL(self.tempStaffModel.password) && CHECK_STRING_NOT_NULL(self.tempStaffModel.pId) && CHECK_STRING_NOT_NULL(self.tempStaffModel.doctorIds)) {
            willPostData = YES;
            self.tempStaffModel.opr = @(1);
        }
    } else {
        if (CHECK_STRING_NOT_NULL(self.tempStaffModel.pId) && CHECK_STRING_NOT_NULL(self.tempStaffModel.doctorIds)) {
            willPostData = YES;
            self.tempStaffModel.opr = @(2);
        }
    }
    if (willPostData) {
        [self postStaff:self.tempStaffModel];
    } else {
        [Utils showToastWithTitle:@"请输入必填项" time:1];
    }
}

- (NSString *)getDoctorsIds {
    NSMutableString *doctorsIds = [NSMutableString string];
    [self.tempStaffModel.hospitalDoctorMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
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
        if (result) {
            if ([result.return_code intValue] == 0) {
                [Utils showToastWithTitle:@"提交数据成功" time:1];
                self.staffModel = self.tempStaffModel;
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
    [self performSegueWithIdentifier:HospitalListSegue sender:self.tempStaffModel];
}
#pragma mark - Text field view delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.contentScrollView setContentOffset:CGPointMake(0, CGRectGetMinY(textField.frame) - 30) animated:YES];
    if (self.payTypeTextField == textField) {
        [self.editingTextFiled resignFirstResponder];
        [self performSegueWithIdentifier:PayTypeSegue sender:self.tempStaffModel];
        return NO;
    }
    self.editingTextFiled = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        self.tempStaffModel.username = self.usernameTextField.text;
    } else if (textField == self.passwordTextField) {
        self.tempStaffModel.password = self.passwordTextField.text;
    } else if (textField == self.nameTextField) {
        self.tempStaffModel.name = self.nameTextField.text;
    } else if (textField == self.chengweiTextField) {
        self.tempStaffModel.chengwei = self.chengweiTextField.text;
    } else if (textField == self.phoneTextField) {
        self.tempStaffModel.phone = self.phoneTextField.text;
    } else if (textField == self.pIdTextField) {
        self.tempStaffModel.pId = self.pIdTextField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.contentScrollView setContentOffset:CGPointZero];
    [textField resignFirstResponder];
    return YES;
}

@end
