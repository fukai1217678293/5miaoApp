//
//  VTWebViewController.m
//  VouteStatement
//
//  Created by 付凯 on 2017/5/11.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTWebViewController.h"
#import <WebKit/WebKit.h>
@interface VTWebViewController ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong)WKWebView *wkWebView;
@property (nonatomic,copy)NSString *navTitle;
@property (nonatomic,copy)NSString *urlString;
@end

@implementation VTWebViewController

- (instancetype)initWithNavTitle:(NSString *)title urlString:(NSString *)urlString {
    if (self = [super init]) {
        self.navTitle = title;
        self.urlString= urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navTitle;
    self.showNormalBackButtonItem = YES;
    self.view.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
    [self.view addSubview:self.wkWebView];
    NSURL * url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}
#pragma mark -- getter
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
