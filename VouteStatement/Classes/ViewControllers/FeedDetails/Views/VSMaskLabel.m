//
//  VSMaskLabel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VSMaskLabel.h"

@interface VSMaskLabel ()


@end

@implementation VSMaskLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.triangleTopLeft = YES;
    }
    return self;
}
#pragma mark -- setter
- (void)setTriangleTopLeft:(BOOL)triangleTopLeft {
    _triangleTopLeft = triangleTopLeft;
    [self setNeedsDisplay];
}

#pragma mark -- drawRect

- (void)drawRect:(CGRect)rect {
    //设置背景颜色
    [[UIColor whiteColor]set];
    UIRectFill([self bounds]);
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    if (self.triangleTopLeft) {
        CGContextMoveToPoint(context,0, 0);//设置起点
        CGContextAddLineToPoint(context,self.width, 0);
        CGContextAddLineToPoint(context,0, self.height);
    }
    else {
        CGContextMoveToPoint(context,0, 0);//设置起点
        CGContextAddLineToPoint(context,self.width, 0);
        CGContextAddLineToPoint(context,self.width, self.height);
    }
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [UIRGBColor(218, 218, 218, 1) setFill];
    //设置填充色
    [[UIColor clearColor] setStroke];
    //设置边框颜色
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
    [super drawRect:self.bounds];
}

@end
