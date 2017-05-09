//
//  FeedWebViewController.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedWebViewController.h"
#import <WebKit/WebKit.h>

@interface FeedWebViewController ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong)WKWebView * wkWebView;

@end

@implementation FeedWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNormalBackButtonItem = YES;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.javaScriptEnabled = YES;
    preferences.minimumFontSize = 0.0f;
    configuration.preferences = preferences;
    
    CGRect frame = self.view.bounds;
    self.wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    
    [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.wkWebView setNavigationDelegate:self];
    [self.wkWebView setUIDelegate:self];
    [self.wkWebView setMultipleTouchEnabled:YES];
    [self.wkWebView setAutoresizesSubviews:YES];
    [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
    self.wkWebView.scrollView.bounces = YES;
//    NSURL * url = [NSURL URLWithString:self.feed.link];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.wkWebView loadRequest:request];
    [self.view addSubview:self.wkWebView];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
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
