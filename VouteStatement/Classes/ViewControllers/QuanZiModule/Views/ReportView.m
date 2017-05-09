//
//  ReportView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "ReportView.h"

static NSInteger kButtonBaseTag = 1000;
@interface ReportView ()

@property (nonatomic,strong)UIView *contentView;
@end

@implementation ReportView

- (instancetype)initWithReportType:(NSReportType)type {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0];
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7];
    }];
    CGRect frame = _contentView.frame;
    frame.origin.y = SCREEN_HEIGHT - _contentView.height;
    [UIView animateWithDuration:0.15 animations:^{
        self.contentView.frame = frame;
    }];
}
- (void)hidden {
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    CGRect frame = _contentView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.15 animations:^{
        self.contentView.frame = frame;
    }];
}
- (void)buttonClicked:(UIButton *)sender {
    [self hidden];
    if (sender.tag == kButtonBaseTag) {
        if (self.actionClickedHandle) {
            self.actionClickedHandle(sender.tag - kButtonBaseTag);
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hidden];
}
#pragma mark -- getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 100)];
        _contentView.backgroundColor = [UIColor clearColor];
        for (int i = 0; i < 2 ; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, i *55, SCREEN_WIDTH, 45);
            button.backgroundColor = [UIColor whiteColor];
            button.tag = kButtonBaseTag +i;
            [button setTitle:i ? @"取消" : @"举报" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexstring:@"333333"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:button];
        }
    }
    return _contentView;
}
@end
