//
//  ECGView.m
//  MobileMedical
//
//  Created by li yuanchao on 14/11/1.
//  Copyright (c) 2014年 liyc. All rights reserved.
//

#import "ECGView.h"

#define StepCount 10

@interface ECGView ()

@property (nonatomic, assign) NSUInteger minValue;
@property (nonatomic, assign) NSUInteger maxValue;
@property (nonatomic, assign) NSUInteger stepValue;
@property (nonatomic, strong) NSArray *pointArray;

@end

@implementation ECGView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *aColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];//blue蓝色
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextFillRect(context, rect);

    aColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
    for (int i = 1; i < 10; i++) {
        CGContextMoveToPoint(context, 0, 10 * i);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), 10 * i);
        CGContextDrawPath(context, kCGPathStroke);
    }

    aColor = [UIColor greenColor];
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
    CGPoint points[self.pointArray.count];
    for (int i = 0; i < self.pointArray.count; i++) {
        CGPoint point = [self.pointArray[i] CGPointValue];
        point.x += 10;
        point.y = 10 + (self.maxValue - point.y) * (CGRectGetHeight(rect) - 20) / (self.maxValue - self.minValue);
        points[i] = point;
    }
    CGContextAddLines(context, points, self.pointArray.count);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)setEcgDataArray:(NSArray *)ecgDataArray {
    _ecgDataArray = ecgDataArray;

    self.minValue = NSUIntegerMax;
    self.maxValue = 0;
    NSUInteger temp;
    NSMutableArray *pointArray = [NSMutableArray array];
    int i = 0;
    for (NSString *value in _ecgDataArray) {
        if (value && value.length > 0) {
            temp = [value intValue];
            if (temp < self.minValue) {
                self.minValue = temp;
            } else if (temp > self.maxValue) {
                self.maxValue = temp;
            }
            CGPoint point = CGPointMake(i++, temp);
            [pointArray addObject:[NSValue valueWithCGPoint:point]];
        }
    }
    self.pointArray = pointArray;
    self.stepValue = (self.maxValue - self.minValue) / StepCount;
}

@end
