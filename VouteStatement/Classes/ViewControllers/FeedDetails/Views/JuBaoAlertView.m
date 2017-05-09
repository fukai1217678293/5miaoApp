//
//  JuBaoAlertView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/3/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "JuBaoAlertView.h"
#import "VTTextView.h"
#import "JuBaoApiManager.h"
#import "PostTagReformer.h"
#import "PostTagApiManager.h"
#import "VTURLResponse.h"
static NSUInteger actionButtonTag = 1000;

@interface JuBaoAlertView ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UIView              *cornerContentView;
@property (nonatomic,strong)VTTextView          *jubaoTextView;
@property (nonatomic,strong)NSString            *fid;
//@property (nonatomic,strong)PostTagApiManager   *postTagApiManager;
@property (nonatomic,strong)JuBaoApiManager     *jubaoApiManager;
@property (nonatomic,strong)NSString            *uxTag;
@property (nonatomic,strong)MBProgressHUD       *uploadHUD;

@end

@implementation JuBaoAlertView

#pragma mark -- public method

- (instancetype)initWithFid:(NSString *)fid {
    if (self = [super init]) {
        self.fid = fid;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:self.cornerContentView];
    }
    return self;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    CGFloat kAnimationDuration = 0.25;
    CAGradientLayer *contentLayer = (CAGradientLayer *)_cornerContentView.layer;
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
- (void)hidden {
    [self performSelectorOnMainThread:@selector(hiddenAnimation) withObject:nil waitUntilDone:YES];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.25 inModes:@[NSDefaultRunLoopMode]];
}

#pragma mark -- event response
- (void)actionClicked:(UIButton *)sender {
    if (sender.tag-actionButtonTag) {//提交
        if (self.jubaoTextView.text.length < 6 || self.jubaoTextView.text.length>255) {
            NSString * errormsg = @"您输入的内容过长或者过短";
            [self.presentViewController showMessage:errormsg inView:self.superview];
            return;
        }
        self.uploadHUD = [self.presentViewController showHUDLoadingWithMessage:@"正在提交" inView:self.superview];
        [self.jubaoApiManager loadData];
    }
    else {
        [self hidden];
    }
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.jubaoApiManager) {
        return @{@"fid":self.fid,
                 @"reason":self.jubaoTextView.text,
                 @"uxtag":self.uxTag};
    }
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    NSLog(@"%@",manager.response.content);
    [self.presentViewController hiddenHUD:self.uploadHUD];
    [self.presentViewController showMessage:@"举报成功,感谢您的反馈\n我们将在24小时内核实后给予相应的处罚" inView:self.superview];
    [self hidden];

}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    [self.presentViewController hiddenHUD:self.uploadHUD];
    [self.presentViewController showMessage:manager.errorMessage inView:self.superview];
}
#pragma mark -- private method
- (void)hiddenAnimation {
    CGFloat kAnimationDuration = 0.25;
    CAGradientLayer *contentLayer = (CAGradientLayer *)_cornerContentView.layer;
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

#pragma mark -- getter
- (UIView *)cornerContentView {
    if (!_cornerContentView) {
        CGRect frame = CGRectZero;
        //高保真计算
        CGFloat scale = 290.0f/320.0f;
        frame.size.width = 290;
        frame.size.height= 185*scale;
        frame.origin.x = (self.width-frame.size.width)/2.0f;
        frame.origin.y = (self.height-frame.size.height)/2.0f;
        _cornerContentView = [[UIView alloc] initWithFrame:frame];
        _cornerContentView.layer.cornerRadius = 5.0f;
        _cornerContentView.layer.masksToBounds= YES;
        _cornerContentView.clipsToBounds = YES;
        _cornerContentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat intervalx = 0.5;
        CGFloat btnW = (_cornerContentView.width-intervalx)/2.0f;
        CGFloat btnH = 45*scale;
        for (int i = 0 ; i < 2; i ++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * btnW + i *intervalx, _cornerContentView.height-btnH, btnW, btnH);
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:i == 0 ? @"关闭" : @"提交" forState:UIControlStateNormal];
            [btn setTitleColor:i == 0 ? UIRGBColor(70, 70, 70, 1) : UIRGBColor(249, 41, 92, 1) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = actionButtonTag + i;
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [_cornerContentView addSubview:btn];
            if (i == 0) {
                CALayer * verticalLine = [[CALayer alloc] init];
                verticalLine.backgroundColor = UIRGBColor(189, 189, 189, 1).CGColor;
                verticalLine.frame = CGRectMake(btn.right, btn.top, intervalx, btnH);
                [_cornerContentView.layer addSublayer:verticalLine];
            }
        }
        CALayer * horizontalLine = [[CALayer alloc] init];
        horizontalLine.backgroundColor = UIRGBColor(189, 189, 189, 1).CGColor;
        horizontalLine.frame = CGRectMake(0, _cornerContentView.height-btnH-intervalx, _cornerContentView.width, intervalx);
        [_cornerContentView.layer addSublayer:horizontalLine];
        
        //icon
        UIButton * iconTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconTitleBtn.frame = CGRectMake((_cornerContentView.width-100)/2.0f, 10, 100, 30);
        [iconTitleBtn setTitle:@"举报" forState:UIControlStateNormal];
        [iconTitleBtn setTitleColor:UIRGBColor(27, 26, 26, 1) forState:UIControlStateNormal];
        [iconTitleBtn setImage:[UIImage imageNamed:@"icon_jubao1.png"] forState:UIControlStateNormal];
//        iconTitleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        iconTitleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        iconTitleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [_cornerContentView addSubview:iconTitleBtn];
        
        VTTextView *textView = [[VTTextView alloc] initWithFrame:CGRectMake(10, iconTitleBtn.bottom +10, _cornerContentView.width-20, horizontalLine.frame.origin.y - iconTitleBtn.bottom-20)];
        textView.placeholder = @"请输入举报原因(6-255字)";
        textView.layer.borderColor = UIRGBColor(162, 162, 162, 1).CGColor;
        textView.layer.borderWidth = 0.5;
        self.jubaoTextView = textView;
        [_cornerContentView addSubview:textView];
        
    }
    return _cornerContentView;
}
//- (PostTagApiManager *)postTagApiManager {
//    if (!_postTagApiManager) {
//        _postTagApiManager = [[PostTagApiManager alloc] init];
//        _postTagApiManager.delegate = self;
//        _postTagApiManager.paramsourceDelegate = self;
//    }
//    return _postTagApiManager;
//}
- (JuBaoApiManager *)jubaoApiManager {
    if (!_jubaoApiManager) {
        _jubaoApiManager = [[JuBaoApiManager alloc] initWithFid:self.fid];
        _jubaoApiManager.delegate = self;
        _jubaoApiManager.paramsourceDelegate = self;
    }
    return _jubaoApiManager;
}

@end
