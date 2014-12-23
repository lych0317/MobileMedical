//
//  LoginViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"
#import "StaffModel.h"
#import "LoginResult.h"
#import "Config.h"
#import "ProtocolManager.h"
#import "Utils.h"
#import "Constants.h"
#import "AppDelegate.h"

#define RegisterSegue @"RegisterSegue"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *username = [Utils getObjectFromUserDefaultWithKey:USER_DEFAULT_KEY_ACCOUNT];
    NSString *password = [Utils getObjectFromUserDefaultWithKey:USER_DEFAULT_KEY_PASSWORD];
    if (CHECK_STRING_NOT_NULL(username) && CHECK_STRING_NOT_NULL(password)) {
        self.usernameTextField.text = username;
        self.passwordTextField.text = password;
    }
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    if (CHECK_STRING_NOT_NULL(username) && CHECK_STRING_NOT_NULL(password)) {
        UserModel *userModel = [[UserModel alloc] init];
        userModel.username = username;
        userModel.password = password;
        [self loginWithUserModel:userModel];
    } else {
        [Utils showToastWithTitle:@"请输入对应项" time:1];
    }
}

- (void)loginWithUserModel:(UserModel *)userModel {
    [Utils showProgressViewTitle:nil];
    [[ProtocolManager sharedManager] postLoginWithUserModel:userModel success:^(id data) {
        [Utils hideProgressViewAfter:0];
        LoginResult *loginResult = data;
        if ([loginResult.return_code intValue] == 0) {
            [Config sharedConfig].access_token = loginResult.access_token;
            [Config sharedConfig].usertype = loginResult.usertype;
            [Config sharedConfig].username = userModel.username;
            [Config sharedConfig].password = userModel.password;
            [Config sharedConfig].name = loginResult.name;
            if ([loginResult.usertype intValue] == 2) {
                [self setupAccountStaff:loginResult];
            }
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate enterMainView];
        } else if ([loginResult.return_code intValue] == 401) {
            [Utils showToastWithTitle:@"用户名、密码错误" time:1];
        } else {
            [Utils showToastWithTitle:@"登录失败，请重试" time:1];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils hideProgressViewAfter:0];
        [Utils showToastWithTitle:@"登录失败，请重试" time:1];
    }];
}

- (void)setupAccountStaff:(LoginResult *)loginResult {
    Config *config = [Config sharedConfig];
    config.accountStaff.username = config.username;
    config.accountStaff.password = config.password;
    config.accountStaff.pId = loginResult.pId;
    config.accountStaff.name = loginResult.name;
    config.accountStaff.chengwei = loginResult.chengwei;
    config.accountStaff.phone = loginResult.phone;
    config.accountStaff.doctorIds = loginResult.doctorIds;
    config.accountStaff.paytype = loginResult.paytype;
    config.accountStaff.opr = @(2);
}

- (IBAction)registerButtonClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:RegisterSegue sender:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
