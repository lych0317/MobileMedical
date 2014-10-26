//
//  OtherDataModel.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "OtherDataModel.h"

@implementation DataItemModel

- (NSDate *)time {
    if (_time == nil) {
        _time = [NSDate date];
    }
    return _time;
}

@end

@implementation OtherDataModel

@end
