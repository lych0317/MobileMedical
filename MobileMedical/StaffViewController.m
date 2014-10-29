//
//  StaffViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "StaffViewController.h"
#import "CollectionManagerTableViewController.h"
#import "DatabaseManager.h"
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

    self.datePicker.backgroundColor = [UIColor whiteColor];

    if (self.staffModel == nil) {
        self.staffModel = [[StaffModel alloc] init];
    }

    [self setupTextField];
}

- (void)setupTextField {
    self.nameTextField.text = self.staffModel.name;
    self.genderTextField.text = self.staffModel.gender;
    self.relationTextField.text = self.staffModel.relation;
    self.phoneTextField.text = self.staffModel.phone;
    self.identifierTextField.text = self.staffModel.identifier;
    self.birthdayTextField.text = [Utils stringDateFromDate:self.staffModel.birthday];
    self.payTypeTextField.text = self.staffModel.payType;
    self.hospitalTextField.text = self.staffModel.hospital;
    self.doctorTextField.text = self.staffModel.doctor;
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
    if (self.editingTextField.text == nil || self.editingTextField.text.length == 0) {
        self.editingTextField.text = self.dataForPicker[[self.textFieldPicker selectedRowInComponent:0]];
    } else {
        [self.textFieldPicker selectRow:[self.dataForPicker indexOfObject:self.editingTextField.text] inComponent:0 animated:YES];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.hidePickerViewButton.hidden = NO;
        self.textFieldPicker.center = CGPointMake(self.textFieldPicker.center.x, self.textFieldPicker.center.y - CGRectGetHeight(self.textFieldPicker.frame));
    }];
}

- (void)hidePickerView {
    [UIView animateWithDuration:0.5 animations:^{
        self.textFieldPicker.center = CGPointMake(self.textFieldPicker.center.x, CGRectGetHeight(self.view.frame) + CGRectGetHeight(self.textFieldPicker.frame) / 2);
    }];
}

- (void)showDatePicker {
    [UIView animateWithDuration:0.5 animations:^{
        self.hidePickerViewButton.hidden = NO;
        self.datePicker.center = CGPointMake(self.datePicker.center.x, self.datePicker.center.y - CGRectGetHeight(self.datePicker.frame));
    }];
}

- (void)hideDatePicker {
    [UIView animateWithDuration:0.5 animations:^{
        self.datePicker.center = CGPointMake(self.datePicker.center.x, CGRectGetHeight(self.view.frame) + CGRectGetHeight(self.datePicker.frame) / 2);
    }];
}

#pragma mark - Selectors

- (void)doneButtonItemClicked:(UIBarButtonItem *)sender {
    self.staffModel.name = self.nameTextField.text;
    self.staffModel.gender = self.genderTextField.text;
    self.staffModel.relation = self.relationTextField.text;
    self.staffModel.phone = self.phoneTextField.text;
    self.staffModel.identifier = self.identifierTextField.text;
    self.staffModel.birthday = [Utils dateFromString:self.birthdayTextField.text];
    self.staffModel.payType = self.payTypeTextField.text;
    self.staffModel.hospital = self.hospitalTextField.text;
    self.staffModel.doctor = self.doctorTextField.text;

    if (![[AppModel sharedAppModel].staffModels containsObject:self.staffModel]) {
        [[AppModel sharedAppModel].staffModels addObject:self.staffModel];
        [[DatabaseManager sharedManager] insertStaff:self.staffModel];
    } else {
        [[DatabaseManager sharedManager] updateStaff:self.staffModel];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)setCollectionType:(UIButton *)sender {
    [self performSegueWithIdentifier:CollectionManagerSegue sender:self.staffModel];
}

- (IBAction)setBirthdayValue:(UIDatePicker *)sender {
    self.birthdayTextField.text = [Utils stringDateFromDate:self.datePicker.date];
}

- (IBAction)hidePickerView:(UIButton *)sender {
    sender.hidden = YES;
    [self hidePickerView];
    [self hideDatePicker];
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
    [self.editingTextField resignFirstResponder];
    self.editingTextField = textField;
    AppModel *appModel = [AppModel sharedAppModel];
    if (textField == self.genderTextField) {
        self.dataForPicker = appModel.genderTitles;
        [self showPickerView];
        allowEditing = NO;
    } else if (textField == self.birthdayTextField) {
        self.birthdayTextField.text = [Utils stringDateFromDate:self.datePicker.date];
        [self showDatePicker];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.editingTextField resignFirstResponder];
    return YES;
}

@end
