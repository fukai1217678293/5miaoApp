//
//  FindDescAlertView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/5/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FindDescAlertView.h"

@implementation FindDescAlertView

+ (instancetype)manager {
    return [[[self class] alloc] init];
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75f];
        self.layer.cornerRadius = 6.0f;
        self.layer.masksToBounds= YES;
        
        UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width-20, self.height-45)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.text = @"这里的话题不属于任何圈子,谁都可以看到。发布话题时不选择圈子即发送到发现。";
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, contentLabel.bottom, self.width, 1.0f);
        lineLayer.backgroundColor = [UIColor colorWithHexstring:@"8a8a8a"].CGColor;
        [self.layer addSublayer:lineLayer];
        
        UIButton *colseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        colseButton.frame = CGRectMake(0, contentLabel.bottom+1, self.width, 44);
        colseButton.backgroundColor = [UIColor clearColor];
        [colseButton setTitle:@"关闭" forState:UIControlStateNormal];
        [colseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [colseButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [colseButton addTarget:self action:@selector(coloseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:colseButton];
    }
    return self;
}
- (void)showInView:(UIView *)view {
    [view addSubview:self];
}
- (void)hidden {
    [VTAppContext shareInstance].showFindDescAlert = YES;
    [self removeFromSuperview];
}
- (void)coloseAction:(UIButton *)sender {
    [self hidden];
}
@end
