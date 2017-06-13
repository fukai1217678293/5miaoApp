//
//  LaunchPageManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/5/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LaunchPageManager.h"
#import <UIKit/UIKit.h>
@implementation LaunchPageManager

+ (void)startHelloPage {
    if ([VTAppContext shareInstance].showHelloPage) {
        [self showPage];
    }
}
+ (void)showPage {
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    pageView.backgroundColor = [UIColor whiteColor];
    pageView.tag = 1000;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:pageView.bounds];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
    scrollView.contentOffset = CGPointZero;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator= NO;
    [pageView addSubview:scrollView];
    
    for (int i = 0 ; i < 3; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.backgroundColor = [UIColor whiteColor];
        NSString * imageName;
        if (IS_IPHONE_4) {
            imageName = [NSString stringWithFormat:@"hello_page_%d_640x960.png",i+1];
        } else {
            imageName = [NSString stringWithFormat:@"hello_page_%d_750x1334.png",i+1];
        }
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        if (i == 2) {
            UIButton *hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect btnFrame;
            if (IS_IPHONE_4) {
                btnFrame = CGRectMake((SCREEN_WIDTH - 120)/2.0f, SCREEN_HEIGHT -110, 120, 45);
            } else if (IS_IPHONE_5) {
                btnFrame = CGRectMake((SCREEN_WIDTH - 120)/2.0f, SCREEN_HEIGHT -120, 120, 45);
            } else if (IS_IPHONE_6) {
                btnFrame = CGRectMake((SCREEN_WIDTH - 130)/2.0f, SCREEN_HEIGHT -140, 130, 50);
            } else if (IS_IPHONE_6Plus) {
                btnFrame = CGRectMake((SCREEN_WIDTH - 130)/2.0f, SCREEN_HEIGHT -140, 130, 50);
            } else {
                btnFrame = CGRectMake((SCREEN_WIDTH - 130)/2.0f, SCREEN_HEIGHT -140, 130, 50);
            }
            hiddenBtn.frame = btnFrame;
            hiddenBtn.backgroundColor = [UIColor clearColor];
            hiddenBtn.layer.cornerRadius = 5.0f;
            hiddenBtn.layer.masksToBounds = YES;
            hiddenBtn.layer.borderColor = [UIColor colorWithHexstring:@"fe3768"].CGColor;
            hiddenBtn.layer.borderWidth = 0.6f;
            [hiddenBtn setTitleColor:[UIColor colorWithHexstring:@"fe3768"] forState:UIControlStateNormal];
            [hiddenBtn setTitle:@"进入APP >>" forState:UIControlStateNormal];
            [hiddenBtn.titleLabel setFont:[UIFont systemFontOfSize:19]];
            [hiddenBtn addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:hiddenBtn];
            imageView.userInteractionEnabled= YES;
        }
    }
    KeyWindow;
    [window addSubview:pageView];
    [window bringSubviewToFront:pageView];
    [VTAppContext shareInstance].showHelloPage = YES;
}
+ (void)startApp {
    KeyWindow;
    UIView *pageView = [window viewWithTag:1000];
    [pageView removeFromSuperview];
}
@end
