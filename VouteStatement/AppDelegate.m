//
//  AppDelegate.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/10.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "AppDelegate.h"
#import "JSRSA.h"
#import "InitApiManager.h"
#import "AppDelegate+AppServince.h"
#import "JWLaunchAd.h"
#import "InitReformer.h"
#import "ViewController.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "FeedDetailViewController.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<VTAPIManagerCallBackDelegate,BMKGeneralDelegate>
@property (nonatomic,assign)BOOL            backgroundActive;

@property (nonatomic,strong)InitApiManager *initialApiManager;
@property (nonatomic,strong)BMKMapManager *mapManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //启动接口
//    [self.initialApiManager loadData];
//    NSData * data = [RSA_PUBLIC_KEY dataUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    NSData *imagedata = [[NSData alloc] initWithBase64EncodedString:RSA_PUBLIC_KEY options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    NSString *base64Decoded = [[NSString alloc]
//                               initWithData:imagedata encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",base64Decoded);

    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化应用第三方服务
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController =self.rootTabbarConfig.rootController;
    self.rootTabbarConfig.haveRedPointTip = NO;
    _mapManager = [[BMKMapManager alloc]init]; 
    BOOL ret = [self.mapManager start:@"yxvubpkvBGK5g7mmrVgNGc90GAGFyzhF"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    [self launchServinceOption:launchOptions];

//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 启动页广告
- (void)launchAdWithImageUrl:(NSString *)url{
    //1.设置启动页广告图片的url
//    NSString *imgUrlString =@"http://imgstore.cdn.sogou.com/app/a/100540002/714860.jpg";
    //2.初始化启动页广告(初始化后,自动添加至视图,不用手动添加)
    [JWLaunchAd initImageWithAttribute:3.0 showSkipType:SkipShowTypeDefault setLaunchAd:^(JWLaunchAd *launchAd) {
        __block JWLaunchAd *weakSelf = launchAd;
        [weakSelf setAnimationSkipWithAttribute:[UIColor redColor] lineWidth:3.0 backgroundColor:nil textColor:nil];
        [launchAd setWebImageWithURL:url options:JWWebImageRefreshCached result:^(UIImage *image, NSURL *url) {
            //3.异步加载图片完成回调(设置图片尺寸)
            weakSelf.launchAdViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } adClickBlock:^{
            //4.点击广告回调
//            NSString *url = @"https://www.baidu.com";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
    }];
}

//void uncaughtExceptionHandler(NSException *exception) {
//    
//    NSLog(@"reason: %@", exception);
//    
//    // Internal error reporting
//    
//}
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]
        ]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self pushToFeedVCWithRemoteInfo:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执 这个 法，选择 是否提醒 户，有Badge、Sound、Alert三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self pushToFeedVCWithRemoteInfo:userInfo];
    }
    completionHandler(); // 系统要求执 这个 法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    [self pushToFeedVCWithRemoteInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    [self pushToFeedVCWithRemoteInfo:userInfo];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
    _backgroundActive = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    _backgroundActive = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    _backgroundActive = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    _backgroundActive = NO;

}
- (void)pushToFeedVCWithRemoteInfo:(NSDictionary *)remoteInfo {
    if (!_backgroundActive) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        FeedDetailViewController *pushVC = [[FeedDetailViewController alloc] init];
        pushVC.hidesBottomBarWhenPushed = YES;
        UITabBarController * rootController = (UITabBarController *)self.window.rootViewController;
        if (![rootController isKindOfClass:[UITabBarController class]]) {
            return;
        }
        pushVC.feed_hash_name = remoteInfo[@"hash"];
        UINavigationController * selectedNav = (UINavigationController *)rootController.selectedViewController;
        //是否存在模态视图
        if (selectedNav.presentedViewController) {
            if ([selectedNav.presentedViewController isMemberOfClass:[UINavigationController class]]) {
                UINavigationController *presentNav = (UINavigationController *)selectedNav.presentedViewController;
                [presentNav pushViewController:pushVC animated:YES];
            }
            else {
                [selectedNav pushViewController:pushVC animated:YES];
            }
        }
        else {
            [selectedNav pushViewController:pushVC animated:YES];
        }
    });
}

#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    InitReformer * reformer = [[InitReformer alloc] init];
    NSDictionary * data = [manager fetchDataWithReformer:reformer];
    
//    [self launchAdWithImageUrl:data[initReformerDataLaunchImageURLStringKey]];
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
//    [self launchAdWithImageUrl:nil];
}
#pragma mark -- getter
- (VTTabbarControllerConfig *)rootTabbarConfig {
    if (!_rootTabbarConfig) {
        _rootTabbarConfig= [[VTTabbarControllerConfig alloc] init];

    }
    return _rootTabbarConfig;
}
- (InitApiManager *)initialApiManager {
    if (!_initialApiManager) {
        _initialApiManager = [[InitApiManager alloc] init];
        _initialApiManager.delegate = self;
    }
    return _initialApiManager;
}

@end
