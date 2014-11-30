//
//  OtherDataCollectViewController.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "OtherDataCollectViewController.h"
#import "OtherDataItemTableViewCell.h"
#import "BaseResult.h"
#import "ProtocolManager.h"
#import "AppModel.h"
#import "OtherDataModel.h"
#import "OperatingStaff.h"
#import "StaffModel.h"
#import "Utils.h"
#import "Config.h"

@interface OtherDataCollectViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation OtherDataCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightBarButtonItem];
    self.datePicker.backgroundColor = [UIColor grayColor];
    self.nameLabel.text = [Config sharedConfig].name;
    if (self.operatingStaff.otherTestType == OtherTestTypeDiet) {
        self.valueTextField.placeholder = @"请输入（克）";
        self.navigationItem.title = @"膳食";
    } else if (self.operatingStaff.otherTestType == OtherTestTypeSport) {
        self.valueTextField.placeholder = @"请输入（卡路里）";
        self.navigationItem.title = @"运动量";
    } else if (self.operatingStaff.otherTestType == OtherTestTypeMedicine) {
        self.valueTextField.placeholder = @"请输入（颗）";
        self.navigationItem.title = @"服药";
    } else if (self.operatingStaff.otherTestType == OtherTestTypeSmoke) {
        self.valueTextField.placeholder = @"请输入（根）";
        self.navigationItem.title = @"抽烟";
    } else if (self.operatingStaff.otherTestType == OtherTestTypeDrink) {
        self.valueTextField.placeholder = @"请输入（mL）";
        self.navigationItem.title = @"饮酒";
    } else if (self.operatingStaff.otherTestType == OtherTestTypeSpirit) {
        self.valueTextField.placeholder = @"请选择";
        self.navigationItem.title = @"精神状态";
    }
}

- (void)addRightBarButtonItem {
    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] init];
    sendBarButtonItem.title = @"上传";
    sendBarButtonItem.target = self;
    sendBarButtonItem.action = @selector(sendButtonClicked:);

    self.navigationItem.rightBarButtonItems = @[sendBarButtonItem];
}

#pragma mark - Selectors

- (void)sendButtonClicked:(UIBarButtonItem *)sender {
    [self.valueTextField resignFirstResponder];
    NSNumber *value = [NSNumber numberWithFloat:[self.valueTextField.text floatValue]];
    if (value) {
        OtherDataModel *model = [[OtherDataModel alloc] init];
        model.datatype = @(self.operatingStaff.otherTestType);
        model.datetime = [Utils stringDateFromDate:self.datePicker.date];
        model.value = value;
        model.pId = self.operatingStaff.staffModel.pId;
        [self uploadOtherData:model];
    } else {
        [Utils showToastWithTitle:@"请正确输入对应项" time:1];
    }
}

- (void)uploadOtherData:(OtherDataModel *)model {
    [Utils showProgressViewTitle:@"上传中"];
    [[ProtocolManager sharedManager] postOtherDataWithOtherDataModel:model success:^(id data) {
        [Utils hideProgressViewAfter:0];
        BaseResult *result = data;
        if ([result.return_code intValue] == 0) {
            [Utils showToastWithTitle:@"上传成功" time:1];
            self.valueTextField.text = @"";
            self.datePicker.date = [NSDate date];
        } else {
            [Utils showToastWithTitle:@"上传失败" time:1];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [Utils hideProgressViewAfter:0];
        [Utils showToastWithTitle:@"上传失败" time:1];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
