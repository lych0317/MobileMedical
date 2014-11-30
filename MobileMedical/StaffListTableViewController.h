//
//  StaffListTableViewController.h
//  MobileMedical
//
//  Created by li yuanchao on 14/11/22.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OperatingStaff;

@interface StaffListTableViewController : UITableViewController

@property (nonatomic, strong) OperatingStaff *operatingStaff;

@end
