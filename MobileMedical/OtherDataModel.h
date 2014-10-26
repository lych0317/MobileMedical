//
//  OtherDataModel.h
//  MobileMedical
//
//  Created by li yuanchao on 14/10/26.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItemModel : NSObject

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *content;

@end

@interface OtherDataModel : NSObject

@property (nonatomic, strong) NSMutableArray *diet;
@property (nonatomic, strong) NSMutableArray *sport;
@property (nonatomic, strong) NSMutableArray *medicine;
@property (nonatomic, strong) NSMutableArray *smoke;
@property (nonatomic, strong) NSMutableArray *drink;
@property (nonatomic, strong) NSMutableArray *spirit;

@end
