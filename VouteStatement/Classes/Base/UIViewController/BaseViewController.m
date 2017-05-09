//
//  BaseViewController.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {
    MBProgressHUD       *_loadingHUD;
}

@property (nonatomic,strong)UIBarButtonItem *backBarItem;

@property (nonatomic,strong)NSMutableArray  *hudCaches;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.showNormalBackButtonItem = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    for (MBProgressHUD *hud in self.hudCaches) {
        [hud hideAnimated:NO];
    }
    self.hudCaches = nil;
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- Public Method 
//show message
- (void)showMessage:(NSString *)message inView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(message, @"HUD message title");
    hud.label.numberOfLines = 0;
    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    hud.offset = CGPointMake(0.f, 0.f);
    [hud hideAnimated:YES afterDelay:2.0f];
}
- (MBProgressHUD *)showHUDLoadingWithMessage:(NSString *)message inView:(UIView *)view {
    if (!view) {
        view = self.view;
    }
    MBProgressHUD * hud= [MBProgressHUD showHUDAddedTo:view animated:YES];
    if ([NSString isBlankString:message]) {
        message = @"";
    }
    // Set the label text.
    hud.label.text = message;
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    [self.hudCaches addObject:hud];
    return hud;
}
- (void)hiddenHUD:(MBProgressHUD *)hud{
    [self.hudCaches removeObject:hud];
    [hud hideAnimated:YES];
}
#pragma mark -- Event Response
- (void)leftItemClicked {
    if (self.backActionhandle) {
        self.backActionhandle ();
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- setter
- (void)setShowNormalBackButtonItem:(BOOL)showNormalBackButtonItem {
    _showNormalBackButtonItem = showNormalBackButtonItem;
    if (showNormalBackButtonItem) {
        self.navigationItem.leftBarButtonItem = self.backBarItem;
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}
#pragma mark --getter
- (UIBarButtonItem *)backBarItem {
    if (!_backBarItem) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setImage:[UIImage imageNamed:@"icon_left.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _backBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _backBarItem;
    
}
- (UIBarButtonItem *)commonRightBarbuttonItem {
    if (!_commonRightBarbuttonItem) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 40, 30);
//        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(leftItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _commonRightBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _commonRightBarbuttonItem;
}
- (NSMutableArray *)hudCaches {
    if (!_hudCaches) {
        _hudCaches = [NSMutableArray arrayWithCapacity:0];
    }
    return _hudCaches;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
