//
//  BloodSugarDisplayTableViewCell.m
//  MobileMedical
//
//  Created by li yuanchao on 14/12/14.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "BloodSugarDisplayTableViewCell.h"
#import "Utils.h"
#import "BloodSugarModel.h"
#import "AppModel.h"

@interface BloodSugarDisplayTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation BloodSugarDisplayTableViewCell

- (void)setBloodSugarModel:(BloodSugarModel *)bloodSugarModel {
    _bloodSugarModel = bloodSugarModel;
    self.timeLabel.text = [Utils stringTimeFromDate:_bloodSugarModel.date];
    self.typeLabel.text = [self typeTitleByType:_bloodSugarModel.type];
    self.valueLabel.text = [NSString stringWithFormat:@"%@ mmol/L", _bloodSugarModel.value];
    self.statusLabel.text = @"正常";
}

- (NSString *)typeTitleByType:(NSNumber *)type {
    __block NSString *retTitle;
    [[AppModel sharedAppModel].bloodSugarTestTypeTitleMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([type isEqualToNumber:obj]) {
            retTitle = key;
            *stop = YES;
        }
    }];
    return retTitle;
}

@end
