//
//  OtherDataItemTableViewCell.h
//  MobileMedical
//
//  Created by li yuanchao on 14/10/26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OtherDataItemTableViewCell;

typedef void(^WillBeginEditingForDate)(OtherDataItemTableViewCell *cell);
typedef void(^WillBeginEditingForTime)(OtherDataItemTableViewCell *cell);
typedef void(^WillReturn)(OtherDataItemTableViewCell *cell);

@interface OtherDataItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@property (nonatomic, copy) WillBeginEditingForDate willBeginEditingForDate;
@property (nonatomic, copy) WillBeginEditingForTime willBeginEditingForTime;
@property (nonatomic, copy) WillReturn willReturn;

@end
