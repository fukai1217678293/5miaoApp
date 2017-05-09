//
//  BaseViewController.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackActionHandle)(void);

@interface BaseViewController : UIViewController

@property (nonatomic,assign)BOOL showNormalBackButtonItem;

@property (nonatomic,copy)BackActionHandle backActionhandle;

@property (nonatomic,strong)UIBarButtonItem *commonRightBarbuttonItem;

- (void)showMessage:(NSString *)message inView:(UIView *)view;
- (MBProgressHUD *)showHUDLoadingWithMessage:(NSString *)message inView:(UIView *)view ;
- (void)hiddenHUD:(MBProgressHUD *)hud;

@end
