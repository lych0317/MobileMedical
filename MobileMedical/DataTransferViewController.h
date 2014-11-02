//
//  DataTransferViewController.h
//  MobileMedical
//
//  Created by 远超李 on 14-10-26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ETCModel, BloodSugarModel;

@interface DataTransferViewController : UIViewController

@property (nonatomic, strong) ETCModel *etcModel;
@property (nonatomic, strong) BloodSugarModel *bloodSugarModel;

@end
