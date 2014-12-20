//
//  ETCDisplayTableViewCell.m
//  MobileMedical
//
//  Created by li yuanchao on 14/12/20.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "ETCDisplayTableViewCell.h"
#import "ETCModel.h"
#import "Utils.h"
#import "ECGView.h"

@interface ETCDisplayTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pulseLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *ecgScrollView;

@property (strong, nonatomic) ECGView *ecgView;

@end

@implementation ETCDisplayTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.ecgView.frame = CGRectMake(0, 0, self.ecgScrollView.contentSize.width, CGRectGetHeight(self.ecgScrollView.frame));
}

- (void)setEtcModel:(ETCModel *)etcModel {
    _etcModel = etcModel;

    self.timeLabel.text = [NSString stringWithFormat:@"时间  %@", [Utils stringTimeFromDate:_etcModel.date]];
    self.pulseLabel.text = [NSString stringWithFormat:@"心率  %@", _etcModel.pulse];
    self.ecgView.ecgDataArray = [_etcModel.ecg componentsSeparatedByString:@","];
    self.ecgScrollView.contentSize = CGSizeMake(self.ecgView.ecgDataArray.count + 20, CGRectGetHeight(self.ecgScrollView.frame));
    [self.ecgScrollView addSubview:self.ecgView];
}

- (ECGView *)ecgView {
    if (_ecgView == nil) {
        _ecgView = [[ECGView alloc] initWithFrame:CGRectZero];
    }
    return _ecgView;
}

@end
