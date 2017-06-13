//
//  QZHomeHeaderView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZHomeHeaderView.h"

@interface QZHomeHeaderView ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton*joinButton;
@property (nonatomic,strong)CALayer *lineLayer;
@property (nonatomic,assign)BOOL isJoined;
@end

@implementation QZHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self.layer addSublayer:self.lineLayer];
    }
    return self;
}
- (void)updateInformationWithDataSource:(QZInformationModel *)model {
    _titleLabel.text = [NSString stringWithFormat:@" %@",model.circle_name];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = [UIImage imageNamed:@"icon_quanzibig.png"]; //要添加的图片
    textAttachment.bounds = CGRectMake(0, 0, 17, 17);
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:_titleLabel.attributedText];
    [att insertAttributedString:textAttachmentString atIndex:0];
    _titleLabel.attributedText = att;
    self.isJoined = model.joined;
}
- (void)joinToQZ:(UIButton *)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(qzHomeHeaderView:didClickedJoinButton:)]) {
            [_delegate qzHomeHeaderView:self didClickedJoinButton:sender];
        }
    }
}
#pragma mark -- setter
- (void)setIsJoined:(BOOL)isJoined {
    _isJoined = isJoined;
    if (!_joinButton) {
        [self addSubview:self.joinButton];
    }
    if (isJoined) {
        [_joinButton.layer removeAllAnimations];
        [_joinButton setTitle:@"已加入" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor colorWithHexstring:@"999999"] forState:UIControlStateNormal];
        _joinButton.layer.borderColor = [UIColor colorWithHexstring:@"999999"].CGColor;
        
    } else {
        [_joinButton setTitle:@"+ 加入" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor colorWithHexstring:@"fe3768"] forState:UIControlStateNormal];
        _joinButton.layer.borderColor = [UIColor colorWithHexstring:@"fe3768"].CGColor;
        CGFloat kAnimationDuration = 1;
        CAGradientLayer *contentLayer = (CAGradientLayer *)_joinButton.layer;
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        scaleAnimation.duration = kAnimationDuration;
        scaleAnimation.cumulative = NO;
        scaleAnimation.repeatCount = MAXFLOAT;
        [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [contentLayer addAnimation: scaleAnimation forKey:@"myScale"];
        
        CABasicAnimation *scaleAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];
        scaleAnimation1.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.2)];
        scaleAnimation1.duration = kAnimationDuration;
        scaleAnimation1.cumulative = NO;
        scaleAnimation1.repeatCount = MAXFLOAT;
        [scaleAnimation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [contentLayer addAnimation: scaleAnimation forKey:@"myScale"];

        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = kAnimationDuration;
        group.removedOnCompletion = NO;
        group.repeatCount = MAXFLOAT;
        group.fillMode = kCAFillModeForwards;
        [group setAnimations:@[scaleAnimation,scaleAnimation1]];
        
        [contentLayer addAnimation:group forKey:@"animationOpacity"];
    }
}
#pragma mark -- getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 100, 50)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping ;
        _titleLabel.font = [UIFont systemFontOfSize:19];
        _titleLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        
    }
    return _titleLabel;
}
- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.frame = CGRectMake(SCREEN_WIDTH - 90, 20, 0.75f, 30);
        _lineLayer.backgroundColor = [UIColor colorWithHexstring:@"e1e1e1"].CGColor;
    }
    return _lineLayer;
}
- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinButton.frame = CGRectMake(SCREEN_WIDTH - 75, 20, 60, 30);
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _joinButton.layer.cornerRadius = 3.0f;
        _joinButton.layer.masksToBounds= YES;
        _joinButton.layer.borderWidth = 0.7f;
        [_joinButton addTarget:self action:@selector(joinToQZ:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}
@end
