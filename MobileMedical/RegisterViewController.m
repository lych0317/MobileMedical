//
//  RegisterViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "RegisterModel.h"
#import "RegisterResult.h"
#import "ProtocolManager.h"
#import "Config.h"
#import "Constants.h"
#import "Utils.h"

@interface RegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTestField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;

@property (weak, nonatomic) IBOutlet UITextField *pIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Config sharedConfig].usertype = @(1);
}

- (IBAction)registerTypeValueChanged:(UISegmentedControl *)sender {
    self.nameTextField.hidden = sender.selectedSegmentIndex == 1;
    self.introTextView.hidden = sender.selectedSegmentIndex == 1;
    self.pIdTextField.hidden = sender.selectedSegmentIndex == 0;
    self.phoneTextField.hidden = sender.selectedSegmentIndex == 0;
    [Config sharedConfig].usertype = @(sender.selectedSegmentIndex + 1);
}

- (IBAction)registerButtonClicked:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTestField.text;
    NSString *confirmPwd = self.confirmPwdTextField.text;
    if ([[Config sharedConfig].usertype intValue] == 1) {
        if (CHECK_STRING_NOT_NULL(username) && CHECK_STRING_NOT_NULL(password) && CHECK_STRING_NOT_NULL(confirmPwd)) {
            if ([password isEqualToString:confirmPwd]) {
                RegisterModel *registerModel = [[RegisterModel alloc] init];
                registerModel.username = username;
                registerModel.password = password;
                registerModel.name = self.nameTextField.text;
                registerModel.intro = self.introTextView.text;
                registerModel.userfrom = [Config sharedConfig].userfrom;
                [self registerWithRegisterModel:registerModel];
            } else {
                [Utils showToastWithTitle:@"两次密码不一致" time:1];
            }
        } else {
            [Utils showToastWithTitle:@"请输入对应项" time:1];
        }
    } else if ([[Config sharedConfig].usertype intValue] == 2) {
        NSString *pId = self.pIdTextField.text;
        if (CHECK_STRING_NOT_NULL(username) && CHECK_STRING_NOT_NULL(password) && CHECK_STRING_NOT_NULL(confirmPwd) && CHECK_STRING_NOT_NULL(pId)) {
            if ([password isEqualToString:confirmPwd]) {
                RegisterModel *registerModel = [[RegisterModel alloc] init];
                registerModel.username = username;
                registerModel.password = password;
                registerModel.userfrom = [Config sharedConfig].userfrom;
                registerModel.pId = pId;
                registerModel.phone = self.phoneTextField.text;
                [self registerWithRegisterModel:registerModel];
            } else {
                [Utils showToastWithTitle:@"两次密码不一致" time:1];
            }
        } else {
            [Utils showToastWithTitle:@"请输入对应项" time:1];
        }
    }
}

- (void)registerWithRegisterModel:(RegisterModel *)registerModel {
    [Utils showProgressViewTitle:nil];
    [[ProtocolManager sharedManager] postRegisterWithRegisterModel:registerModel success:^(id data) {
        [Utils hideProgressViewAfter:0];
        RegisterResult *registerResult = data;
        if ([registerResult.return_code intValue] == 0) {
            [Config sharedConfig].access_token = registerResult.access_token;
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate enterMainView];
        } else if ([registerResult.return_code intValue] == 4) {
            [Utils showToastWithTitle:@"用户名已存在" time:1];
        } else if ([registerResult.return_code intValue] == 6) {
            [Utils showToastWithTitle:@"身份证已存在" time:1];
        } else {
            [Utils showToastWithTitle:@"注册失败，请重试" time:1];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils hideProgressViewAfter:0];
        [Utils showToastWithTitle:@"注册失败，请重试" time:1];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
