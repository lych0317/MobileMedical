//
//  AccountDataViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "AccountDataViewController.h"
#import "HospitalListTableViewController.h"
#import "PayTypeTableViewController.h"
#import "ProtocolManager.h"
#import "StaffModel.h"
#import "BaseResult.h"
#import "Config.h"
#import "AppModel.h"
#import "Utils.h"
#import "Constants.h"

#define HospitalListSegue @"HospitalListSegue"
#define PayTypeSegue @"PayTypeSegue"

@interface AccountDataViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *accountDataScrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *chengweiTextField;
@property (weak, nonatomic) IBOutlet UITextField *pIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *paytypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *chooseDoctorButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *updatePwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *updatePwdButton;

@property (nonatomic, strong) StaffModel *tempStaffModel;

@end

@implementation AccountDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Config *config = [Config sharedConfig];
    BOOL isGroupUser = [config.usertype intValue] == 1;
    self.usernameLabel.hidden = !isGroupUser;
    self.oldPwdTextField.hidden = !isGroupUser;
    self.updatePwdTextField.hidden = !isGroupUser;
    self.confirmPwdTextField.hidden = !isGroupUser;
    self.updatePwdButton.hidden = !isGroupUser;

    BOOL isStaffUser = [config.usertype intValue] == 2;
    self.usernameTextField.hidden = !isStaffUser;
    self.nameTextField.hidden = !isStaffUser;
    self.chengweiTextField.hidden = !isStaffUser;
    self.pIdTextField.hidden = !isStaffUser;
    self.phoneTextField.hidden = !isStaffUser;
    self.paytypeTextField.hidden = !isStaffUser;
    self.chooseDoctorButton.hidden = !isStaffUser;
    self.submitButton.hidden = !isStaffUser;

    self.tempStaffModel = config.accountStaff;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Config *config = [Config sharedConfig];
    BOOL isGroupUser = [config.usertype intValue] == 1;
    BOOL isStaffUser = [config.usertype intValue] == 2;

    if (isGroupUser) {
        self.usernameLabel.text = config.username;
    } else if (isStaffUser) {
        self.usernameTextField.text = self.tempStaffModel.username;
        self.nameTextField.text = self.tempStaffModel.name;
        self.chengweiTextField.text = self.tempStaffModel.chengwei;
        self.pIdTextField.text = self.tempStaffModel.pId;
        self.phoneTextField.text = self.tempStaffModel.phone;
        if (self.tempStaffModel.paytype) {
            int payType = [self.tempStaffModel.paytype intValue];
            if (payType > 0 && payType <= [AppModel sharedAppModel].payTypeTitles.count) {
                self.paytypeTextField.text = [AppModel sharedAppModel].payTypeTitles[payType - 1];
            }
        }
    }
}

- (IBAction)chooseDoctorButtonClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:HospitalListSegue sender:self.tempStaffModel];
}
- (IBAction)submitButtonClicked:(UIButton *)sender {
    if (CHECK_STRING_NOT_NULL(self.tempStaffModel.username) && CHECK_STRING_NOT_NULL(self.tempStaffModel.pId) && CHECK_STRING_NOT_NULL(self.tempStaffModel.doctorIds)) {
        [self updateStaff:self.tempStaffModel];
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

- (void)updateStaff:(StaffModel *)staffModel {
    [Utils showProgressViewTitle:@"正在提交数据"];
    [[ProtocolManager sharedManager] postStaffWithStaffModel:staffModel success:^(id data) {
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

- (IBAction)updatePwdButtonClicked:(UIButton *)sender {
    NSString *oldPwd = self.oldPwdTextField.text;
    NSString *updatePwd = self.updatePwdTextField.text;
    NSString *confirmPwd = self.confirmPwdTextField.text;
    if (CHECK_STRING_NOT_NULL(oldPwd) && CHECK_STRING_NOT_NULL(updatePwd) && CHECK_STRING_NOT_NULL(confirmPwd)) {
        if ([updatePwd isEqualToString:confirmPwd]) {
            [self updatePassword:oldPwd update:updatePwd];
        } else {
            [Utils showToastWithTitle:@"两次新密码不一致" time:1];
        }
    } else {
        [Utils showToastWithTitle:@"请输入所有项" time:1];
    }
}

- (void)updatePassword:(NSString *)oldPwd update:(NSString *)updatePwd {
    [Utils showProgressViewTitle:@"正在提交数据"];
    [[ProtocolManager sharedManager] postUpdatePasswordWithOldPwd:oldPwd updatePwd:updatePwd success:^(id data) {
        [Utils hideProgressViewAfter:0];
        BaseResult *result = data;
        if ([result.return_code intValue] == 0) {
            [Utils showToastWithTitle:@"修改密码成功" time:1];
            [Config sharedConfig].password = updatePwd;
        } else {
            [Utils showToastWithTitle:@"修改密码失败" time:1];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils hideProgressViewAfter:0];
        [Utils showToastWithTitle:@"修改密码失败" time:1];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.accountDataScrollView setContentOffset:CGPointMake(0, CGRectGetMinY(textField.frame) - 30) animated:YES];
    if (self.paytypeTextField == textField) {
        [self performSegueWithIdentifier:PayTypeSegue sender:self.tempStaffModel];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        self.tempStaffModel.username = self.usernameTextField.text;
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
    [self.accountDataScrollView setContentOffset:CGPointZero animated:YES];
    [textField resignFirstResponder];
    return YES;
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

@end
