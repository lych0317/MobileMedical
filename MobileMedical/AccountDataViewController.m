//
//  AccountDataViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "AccountDataViewController.h"
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

@end

@implementation AccountDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Config *config = [Config sharedConfig];
    self.usernameLabel.hidden = [config.usertype intValue] == 2;
    self.oldPwdTextField.hidden = [config.usertype intValue] == 2;
    self.updatePwdTextField.hidden = [config.usertype intValue] == 2;
    self.confirmPwdTextField.hidden = [config.usertype intValue] == 2;
    self.updatePwdButton.hidden = [config.usertype intValue] == 2;

    self.usernameTextField.hidden = [config.usertype intValue] == 1;
    self.nameTextField.hidden = [config.usertype intValue] == 1;
    self.chengweiTextField.hidden = [config.usertype intValue] == 1;
    self.pIdTextField.hidden = [config.usertype intValue] == 1;
    self.phoneTextField.hidden = [config.usertype intValue] == 1;
    self.paytypeTextField.hidden = [config.usertype intValue] == 1;
    self.chooseDoctorButton.hidden = [config.usertype intValue] == 1;
    self.submitButton.hidden = [config.usertype intValue] == 1;

    if ([config.usertype intValue] == 1) {
        self.usernameLabel.text = config.username;
    } else if ([config.usertype intValue] == 2) {
        self.usernameTextField.text = config.username;
        self.nameTextField.text = config.name;
        self.chengweiTextField.text = config.chengwei;
        self.pIdTextField.text = config.pId;
        self.phoneTextField.text = config.phone;
        if (config.paytype) {
            int payType = [config.paytype intValue];
            if (payType > 0 && payType <= [AppModel sharedAppModel].payTypeTitles.count) {
                self.paytypeTextField.text = [AppModel sharedAppModel].payTypeTitles[payType - 1];
            }
        }
    }
}

- (IBAction)chooseDoctorButtonClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:HospitalListSegue sender:nil];
}
- (IBAction)submitButtonClicked:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *pId = self.pIdTextField.text;
    NSString *doctorIds = [self getDoctorsIds];
    if (CHECK_STRING_NOT_NULL(username) && CHECK_STRING_NOT_NULL(pId) && CHECK_STRING_NOT_NULL(doctorIds)) {
        StaffModel *staffModel = [[StaffModel alloc] init];
        staffModel.pId = pId;
        staffModel.username = username;
        staffModel.name = self.nameTextField.text;
        staffModel.chengwei = self.chengweiTextField.text;
        staffModel.phone = self.phoneTextField.text;
        staffModel.doctorIds = doctorIds;
        staffModel.paytype = [Config sharedConfig].paytype;
        staffModel.opr = @(2);
        [self updateStaff:staffModel];
    } else {
        [Utils showToastWithTitle:@"请输入必填项" time:1];
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

- (void)updateStaff:(StaffModel *)staffModel {
    [Utils showProgressViewTitle:@"正在提交数据"];
    [[ProtocolManager sharedManager] postStaffWithStaffModel:staffModel success:^(id data) {
        [Utils hideProgressViewAfter:0];
        BaseResult *result = data;
        if ([result.return_code intValue] == 0) {
            [Utils showToastWithTitle:@"提交数据成功" time:1];
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
        [self performSegueWithIdentifier:PayTypeSegue sender:nil];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [Config sharedConfig].username = self.usernameTextField.text;
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
    [self.accountDataScrollView setContentOffset:CGPointZero animated:YES];
    [textField resignFirstResponder];
    return YES;
}

@end
