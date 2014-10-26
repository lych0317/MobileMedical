//
//  OtherDataCollectViewController.m
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "OtherDataCollectViewController.h"
#import "OtherDataItemTableViewCell.h"
#import "AppModel.h"
#import "OtherDataModel.h"
#import "Utils.h"

@interface OtherDataCollectViewController ()

@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UIButton *hidePickerViewButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) NSMutableArray *editingCategoryData;
@property (nonatomic, strong) UITextField *editingTextField;

@end

@implementation OtherDataCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editingCategoryData = [AppModel sharedAppModel].otherDataModel.diet;
    [self addRightBarButtonItem];
    self.datePicker.backgroundColor = [UIColor whiteColor];
}

- (void)addRightBarButtonItem {
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] init];
    addBarButtonItem.title = @"添加";
    addBarButtonItem.target = self;
    addBarButtonItem.action = @selector(addButtonClicked:);

    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] init];
    sendBarButtonItem.title = @"上传";
    sendBarButtonItem.target = self;
    sendBarButtonItem.action = @selector(sendButtonClicked:);

    self.navigationItem.rightBarButtonItems = @[sendBarButtonItem, addBarButtonItem];
}

- (void)setAddBarButtonItemEnabled:(BOOL)enabled {
    UIBarButtonItem *addBarButtonItem = self.navigationItem.rightBarButtonItems[1];
    addBarButtonItem.enabled = enabled;
}

- (void)showDatePickerWithIsDateType:(BOOL)isDateType {
    if (isDateType) {
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    } else {
        self.datePicker.datePickerMode = UIDatePickerModeTime;
    }
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

- (void)addButtonClicked:(UIBarButtonItem *)sender {
    sender.enabled = NO;
    DataItemModel *dataItemModel = [[DataItemModel alloc] init];
    [self.editingCategoryData addObject:dataItemModel];
    [self.dataTableView reloadData];
}

- (void)sendButtonClicked:(UIBarButtonItem *)sender {

}

- (IBAction)categoryValueChanged:(UISegmentedControl *)sender {
    DataItemModel *lastDataItemModel = [self.editingCategoryData lastObject];
    if (lastDataItemModel.content == nil || lastDataItemModel.content.length == 0) {
        [self.editingCategoryData removeLastObject];
    }
    NSString *title = nil;
    OtherDataModel *otherDataModel = [AppModel sharedAppModel].otherDataModel;
    switch (sender.selectedSegmentIndex) {
        case 0:
            title = @"食盐量";
            self.editingCategoryData = otherDataModel.diet;
            break;
        case 1:
            title = @"运动量";
            self.editingCategoryData = otherDataModel.sport;
            break;
        case 2:
            title = @"服药量";
            self.editingCategoryData = otherDataModel.medicine;
            break;
        case 3:
            title = @"抽烟量";
            self.editingCategoryData = otherDataModel.smoke;
            break;
        case 4:
            title = @"饮酒量";
            self.editingCategoryData = otherDataModel.drink;
            break;
        case 5:
            title = @"精神状况";
            self.editingCategoryData = otherDataModel.spirit;
            break;
        default:
            break;
    }
    self.categoryTitle.text = title;
    [self.dataTableView reloadData];
    [self setAddBarButtonItemEnabled:YES];
}

- (IBAction)hidePickerView:(UIButton *)sender {
    sender.hidden = YES;
    [self hideDatePicker];
}

- (IBAction)setDateValue:(UIDatePicker *)sender {
    NSString *stringDate;
    if (sender.datePickerMode == UIDatePickerModeDate) {
        stringDate = [Utils stringDateFromDate:sender.date];
    } else {
        stringDate = [Utils stringTimeFromDate:sender.date];
    }
    self.editingTextField.text = stringDate;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.editingCategoryData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OtherDataItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    DataItemModel *dataItemModel = self.editingCategoryData[indexPath.row];
    cell.dateTextField.text = [Utils stringDateFromDate:dataItemModel.time];
    cell.timeTextField.text = [Utils stringTimeFromDate:dataItemModel.time];
    cell.contentTextField.text = dataItemModel.content;
    cell.willBeginEditingForDate = ^(OtherDataItemTableViewCell *cell) {
        self.editingTextField = cell.dateTextField;
        [self showDatePickerWithIsDateType:YES];
    };
    cell.willBeginEditingForTime = ^(OtherDataItemTableViewCell *cell) {
        self.editingTextField = cell.timeTextField;
        [self showDatePickerWithIsDateType:NO];
    };
    cell.willReturn = ^(OtherDataItemTableViewCell *cell) {
        dataItemModel.time = [Utils dateFromStringDate:cell.dateTextField.text time:cell.timeTextField.text];
        dataItemModel.content = cell.contentTextField.text;
        [self setAddBarButtonItemEnabled:YES];
    };
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.editingCategoryData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
