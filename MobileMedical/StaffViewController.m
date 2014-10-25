//
//  StaffViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "StaffViewController.h"
#import "CollectionManagerTableViewController.h"
#import "AppModel.h"
#import "StaffModel.h"
#import "Utils.h"

#define CollectionManagerSegue @"CollectionManagerSegue"

@interface StaffViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *relationTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *identifierTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *payTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *hospitalTextField;
@property (weak, nonatomic) IBOutlet UITextField *doctorTextField;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *hidePickerViewButton;

@property (weak, nonatomic) IBOutlet UIPickerView *textFieldPicker;
@property (nonatomic, strong) NSArray *dataForPicker;


@property (nonatomic, strong) UITextField *editingTextField;

@end

@implementation StaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightBarButtonItem];

    [self setupTextField];
}

- (void)setupTextField {
    self.nameTextField.text = self.staffModel.name;
    self.genderTextField.text = self.staffModel.gender;
    self.relationTextField.text = self.staffModel.relation;
    self.phoneTextField.text = self.staffModel.phone;
    self.identifierTextField.text = self.staffModel.identifier;
    self.birthdayTextField.text = [self stringFromDate:self.staffModel.birthday];
    self.payTypeTextField.text = self.staffModel.payType;
    self.hospitalTextField.text = self.staffModel.hospital;
    self.doctorTextField.text = self.staffModel.doctor;
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
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
    self.navigationItem.title = @"人员";
    self.hidePickerViewButton.hidden = YES;
    self.textFieldPicker.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.textFieldPicker.frame), CGRectGetHeight(self.textFieldPicker.frame));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"取消";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:CollectionManagerSegue]) {
        CollectionManagerTableViewController *viewController = segue.destinationViewController;
        viewController.staffModel = sender;
    }
}

- (void)showPickerView {
    [self.textFieldPicker reloadAllComponents];
    [UIView animateWithDuration:0.5 animations:^{
        self.hidePickerViewButton.hidden = NO;
        self.textFieldPicker.center = CGPointMake(self.textFieldPicker.center.x, self.textFieldPicker.center.y - CGRectGetHeight(self.textFieldPicker.frame));
    }];
}

- (void)hidePickerView {
    [UIView animateWithDuration:0.5 animations:^{
        self.textFieldPicker.center = CGPointMake(self.textFieldPicker.center.x, self.textFieldPicker.center.y + CGRectGetHeight(self.textFieldPicker.frame));
    }];
}

#pragma mark - Selectors

- (void)doneButtonItemClicked:(UIBarButtonItem *)sender {
}

- (IBAction)setCollectionType:(UIButton *)sender {
    [self performSegueWithIdentifier:CollectionManagerSegue sender:self.staffModel];
}

- (IBAction)setBirthdayValue:(id)sender {

}

- (IBAction)hidePickerView:(UIButton *)sender {
    sender.hidden = YES;
    [self hidePickerView];
}
#pragma mark - picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataForPicker[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.editingTextField.text = self.dataForPicker[row];
}

#pragma mark - picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataForPicker.count;
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.numberOfButtons - 1) {
        self.editingTextField.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}

#pragma mark - Text field view delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    self.editingTextField = textField;
    AppModel *appModel = [AppModel sharedAppModel];
    if (textField == self.genderTextField) {
        self.dataForPicker = appModel.genderTitles;
        [self showPickerView];
        allowEditing = NO;
    } else if (textField == self.birthdayTextField) {
        allowEditing = NO;
    } else if (textField == self.payTypeTextField) {
        self.dataForPicker = appModel.payTypeTitles;
        [self showPickerView];
        allowEditing = NO;
    } else if (textField == self.hospitalTextField) {
        self.dataForPicker = appModel.hospitalAndDoctorTitleMap.allKeys;
        [self showPickerView];
        allowEditing = NO;
    } else if (textField == self.doctorTextField) {
        if (self.hospitalTextField.text == nil || self.hospitalTextField.text.length == 0) {
            [Utils showToastWithTitle:@"请先选择医院" time:1];
        } else {
            self.dataForPicker = appModel.hospitalAndDoctorTitleMap[self.hospitalTextField.text];
            [self showPickerView];
        }
        allowEditing = NO;
    }
    return allowEditing;
}

@end
