//
//  StaffViewController.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/23.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "StaffViewController.h"

#define CollectionManagerSegue @"CollectionManagerSegue"

@interface StaffViewController ()

@end

@implementation StaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightBarButtonItem];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"取消";
}

#pragma mark - Selectors

- (void)doneButtonItemClicked:(UIBarButtonItem *)sender {
}

- (IBAction)setCollectionType:(UIButton *)sender {
    [self performSegueWithIdentifier:CollectionManagerSegue sender:nil];
}
@end
