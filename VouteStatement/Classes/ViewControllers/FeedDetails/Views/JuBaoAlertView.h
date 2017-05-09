//
//  JuBaoAlertView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/3/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface JuBaoAlertView : UIView


- (instancetype)initWithFid:(NSString *)fid;
//
- (void)showInView:(UIView *)view;
//
- (void)hidden;

@property (nonatomic,strong)BaseViewController *presentViewController;

@end
