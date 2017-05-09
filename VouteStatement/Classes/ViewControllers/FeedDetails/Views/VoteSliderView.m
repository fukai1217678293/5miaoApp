//
//  SliderView.m
//  Demo
//
//  Created by 付凯 on 2017/2/10.
//  Copyright © 2017年 付凯. All rights reserved.
//

#import "VoteSliderView.h"

#define AgreePartViewSelectedColor      UIRGBColor(233, 171, 42, 1)
#define DisagreePartViewSelectedColor   UIRGBColor(20, 146, 121, 1)
#define NormalDeselectedGrayColor       UIRGBColor(90, 91, 93, 1)

NSString * const VoteSliderFilterViewStatusDidChangedNotificationName = @"VoteSliderFilterViewStatusDidChangedNotificationName";

@interface VoteSliderView ()

@property (nonatomic,strong)UIView *agreePartView;
@property (nonatomic,strong)UIView *allPointPartView;
@property (nonatomic,strong)UIView *disagreePartView;

@end

@implementation VoteSliderView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //配置部分
        self.minimumValue = 1;// 设置最小值
        self.maximumValue = 10;// 设置最大值
        self.value = (self.minimumValue + self.maximumValue) / 2;// 设置初始值
        self.continuous = NO;// 设置可连续变化
        self.minimumTrackTintColor = [UIColor clearColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
        self.maximumTrackTintColor = [UIColor clearColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
        [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        [self setThumbImage:[UIImage imageNamed:@"icon_middle.png"] forState:UIControlStateNormal];
        [self setThumbImage:[UIImage imageNamed:@"icon_middle.png"] forState:UIControlStateHighlighted];
        
        //视图部分
        //赞成
        [self addSubview:self.agreePartView];
        CGFloat width = (frame.size.width-4)/3.0f;
        self.agreePartView.frame = CGRectMake(0, 0, width, frame.size.height);
        //赞成圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_agreePartView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _agreePartView.bounds;
        maskLayer.path = maskPath.CGPath;
        _agreePartView.layer.mask = maskLayer;
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_agreePartView.right, 0, 2, frame.size.height)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        //全部
        [self addSubview:self.allPointPartView];
        self.allPointPartView.frame = CGRectMake(lineView.right, 0, width, frame.size.height);
        //分割线
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(_allPointPartView.right, 0, 2, frame.size.height)];
        lineView1.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView1];
        //不赞成
        [self addSubview:self.disagreePartView];
        self.disagreePartView.frame = CGRectMake(lineView1.right, 0, width, frame.size.height);
        //不赞成圆角
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_disagreePartView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = _disagreePartView.bounds;
        maskLayer1.path = maskPath1.CGPath;
        _disagreePartView.layer.mask = maskLayer1;
        //视图层级
        [self sendSubviewToBack:_agreePartView];
        [self sendSubviewToBack:_disagreePartView];
        [self sendSubviewToBack:_allPointPartView];
    }
    return self;
}
- (void)sliderValueChanged:(VoteSliderView *)sender {
    //1--2--3--4--5--6--7--8--9--10
    SliderViewFilterState state;
    if (sender.value < 4) {
        state = SliderViewFilterStateShowLeft;
        [sender setValue:2.5 animated:YES];
        [sender setThumbImage:[UIImage imageNamed:@"icon_filter_left.png"] forState:UIControlStateNormal];
        [sender setThumbImage:[UIImage imageNamed:@"icon_filter_left.png"] forState:UIControlStateHighlighted];
        sender.agreePartView.backgroundColor    = AgreePartViewSelectedColor;
        sender.allPointPartView.backgroundColor = NormalDeselectedGrayColor;
        sender.disagreePartView.backgroundColor = NormalDeselectedGrayColor;

    }
    else if (sender.value >=4 && sender.value <=7) {
        state = SliderViewFilterStateShowAll;
        [sender setValue:5.5 animated:YES];
        [sender setThumbImage:[UIImage imageNamed:@"icon_middle.png"] forState:UIControlStateNormal];
        [sender setThumbImage:[UIImage imageNamed:@"icon_middle.png"] forState:UIControlStateHighlighted];
        sender.agreePartView.backgroundColor    = AgreePartViewSelectedColor;
        sender.allPointPartView.backgroundColor = NormalDeselectedGrayColor;
        sender.disagreePartView.backgroundColor = DisagreePartViewSelectedColor;
    }
    else {
        state = SliderViewFilterStateShowRight;
        [sender setValue:8.5 animated:YES];
        [sender setThumbImage:[UIImage imageNamed:@"icon_rigjt.png"] forState:UIControlStateNormal];
        [sender setThumbImage:[UIImage imageNamed:@"icon_rigjt.png"] forState:UIControlStateHighlighted];
        sender.agreePartView.backgroundColor    = NormalDeselectedGrayColor;
        sender.allPointPartView.backgroundColor = NormalDeselectedGrayColor;
        sender.disagreePartView.backgroundColor = DisagreePartViewSelectedColor;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:VoteSliderFilterViewStatusDidChangedNotificationName object:nil userInfo:@{@"state":@(state)}];
}
//// 设置最大值
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(0, 0, CGRectGetWidth(self.frame)/ 2, CGRectGetHeight(self.frame) / 2);
//}
//// 设置最小值
//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//}

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

// 改变滑块的触摸范围
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value], 10, 10);
}

- (UIView *)agreePartView {
    if (!_agreePartView) {
        _agreePartView = [[UIView alloc] init];
        _agreePartView.backgroundColor = AgreePartViewSelectedColor;
        _agreePartView.userInteractionEnabled = NO;
       
    }
    return _agreePartView;
}
- (UIView *)disagreePartView {
    if (!_disagreePartView) {
        _disagreePartView = [[UIView alloc] init];
        _disagreePartView.backgroundColor = DisagreePartViewSelectedColor;
        _disagreePartView.userInteractionEnabled = NO;
    }
    return _disagreePartView;
}
- (UIView *)allPointPartView {
    if (!_allPointPartView) {
        _allPointPartView = [[UIView alloc] init];
        _allPointPartView.backgroundColor = NormalDeselectedGrayColor;
        _allPointPartView.userInteractionEnabled = NO;
    }
    return _allPointPartView;
}

@end
