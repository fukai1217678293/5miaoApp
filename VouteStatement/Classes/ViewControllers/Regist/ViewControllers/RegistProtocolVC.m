//
//  RegistProtocolVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/5.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "RegistProtocolVC.h"
#import <WebKit/WebKit.h>

@interface RegistProtocolVC ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)WKWebView * wkWebView;

@end

@implementation RegistProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNormalBackButtonItem = YES;
    [self.view addSubview:self.wkWebView];
    NSURL * url = [NSURL URLWithString:@"https://www.anyknew.com/eula"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - getter
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.javaScriptEnabled = YES;
        preferences.minimumFontSize = 0.0f;
        configuration.preferences = preferences;
        CGRect frame = self.view.bounds;
        _wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        [_wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_wkWebView setNavigationDelegate:self];
        [_wkWebView setUIDelegate:self];
        [_wkWebView setMultipleTouchEnabled:YES];
        [_wkWebView setAutoresizesSubviews:YES];
        [_wkWebView.scrollView setAlwaysBounceVertical:YES];
        _wkWebView.scrollView.bounces = YES;
    }
    return _wkWebView;
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
