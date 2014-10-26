//
//  OtherDataItemTableViewCell.m
//  MobileMedical
//
//  Created by li yuanchao on 14/10/26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "OtherDataItemTableViewCell.h"

@implementation OtherDataItemTableViewCell

#pragma mark - Text field view delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    if (textField == self.dateTextField) {
        if (self.willBeginEditingForDate) {
            self.willBeginEditingForDate(self);
        }
        allowEditing = NO;
    } else if (textField == self.timeTextField) {
        if (self.willBeginEditingForTime) {
            self.willBeginEditingForTime(self);
        }
        allowEditing = NO;
    }
    return allowEditing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.willReturn) {
        self.willReturn(self);
    }
    return YES;
}

@end

