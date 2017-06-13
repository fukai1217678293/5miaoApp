//
//  QZDesAlertView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/29.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZDesAlertView.h"

@interface QZDesAlertView ()

@property (nonatomic,strong)UIView *contentView;

@end

@implementation QZDesAlertView

+ (instancetype)manager {
    return [[self alloc] init];
}
- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [self addSubview:self.contentView];
    }
    return self;
}
- (void)showInView:(UIView *)view {
    [view addSubview:self];
    CGFloat kAnimationDuration = 0.25;
    CAGradientLayer *contentLayer = (CAGradientLayer *)_contentView.layer;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [contentLayer addAnimation: scaleAnimation forKey:@"myScale"];
    
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:0.0];
    showViewAnn.toValue = [NSNumber numberWithFloat:1.0];
    showViewAnn.duration = kAnimationDuration;
    showViewAnn.fillMode = kCAFillModeForwards;
    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    showViewAnn.removedOnCompletion = NO;
    [contentLayer addAnimation:showViewAnn forKey:@"myShow"];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = kAnimationDuration;
    group.removedOnCompletion = NO;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    [group setAnimations:@[scaleAnimation,showViewAnn]];
    
    [contentLayer addAnimation:group forKey:@"animationOpacity"];
    
}
- (void)hiddenAnimation {
    CGFloat kAnimationDuration = 0.25;
    CAGradientLayer *contentLayer = (CAGradientLayer *)_contentView.layer;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [contentLayer addAnimation: scaleAnimation forKey:@"myScale"];
    
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:1.0];
    showViewAnn.toValue = [NSNumber numberWithFloat:0.0];
    showViewAnn.duration = kAnimationDuration;
    showViewAnn.fillMode = kCAFillModeForwards;
    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    showViewAnn.removedOnCompletion = NO;
    [contentLayer addAnimation:showViewAnn forKey:@"myShow"];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = kAnimationDuration;
    group.removedOnCompletion = NO;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    [group setAnimations:@[scaleAnimation,showViewAnn]];
    
    [contentLayer addAnimation:group forKey:@"animationOpacity"];
}

- (void)closeActionClicked{
    [self hiddenAnimation];
    [self performSelector:@selector(remove) withObject:nil afterDelay:0.25];
}
- (void)remove {
    [self removeFromSuperview];
}
#pragma mark --getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0f, (SCREEN_HEIGHT-190)/2.0f, 300, 190)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 4.5f;
        _contentView.layer.masksToBounds = YES;
        
        NSString *text = @"圈子是一个私密交流场所,在这没人知道你的真实身份。加入圈子是神秘的,需要圈内人邀请。圈子内的信息24小时自动删除,拒绝挖坟。\n\n快创建你的圈子吧。";
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 270, 145)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = text;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorWithHexstring:@"666666"];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [_contentView addSubview:titleLabel];
        
        CALayer *line = [[CALayer alloc] init];
        line.backgroundColor = [UIColor colorWithHexstring:@"e1e1e1"].CGColor;
        line.frame = CGRectMake(0, titleLabel.bottom, _contentView.width, 0.75);
        [_contentView.layer addSublayer:line];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(0, titleLabel.bottom+0.75, _contentView.width, 45);
        closeButton.backgroundColor =[UIColor clearColor];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithHexstring:@"333333"] forState:UIControlStateNormal];
        closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [closeButton addTarget:self action:@selector(closeActionClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeButton];
    }
    return _contentView;
}
@end
