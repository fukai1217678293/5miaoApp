//
//  AppDelegate+AppServince.m
//  VouteStatement
//
//  Created by 付凯 on 2017/3/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "AppDelegate+AppServince.h"
#import "AppDelegateHeader.h"
#import "UMMobClick/MobClick.h"
#import "UMSocialCore/UMSocialCore.h"
#import <IQKeyboardManager.h>
#import "VersionManager.h"
#import "NotificationManager.h"
#import "FeedDetailViewController.h"
#import "QZListVC.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h> 
#endif

#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

@implementation AppDelegate (AppServince)

- (void)launchServinceOption:(NSDictionary *)launchOption {
    [self umLaunchOptions];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[NotificationManager sharedManager] startMonitoring];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加 定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOption appKey:JPushAppKey
                          channel:JPushChannel
                 apsForProduction:IsProduction];
    NSDictionary * userInfo;

    if (!IOS10) {
        
        if (launchOption) {
            
            UIViewController *rootViewController = self.window.rootViewController;
            
            if ([rootViewController isKindOfClass:[UITabBarController class]]) {
                
                userInfo = [launchOption objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
                //通过远程推送打开
                if (userInfo) {
                    [self pushToFeedVCWithRemoteInfo:userInfo];
                }
                
            }
        }
    }
    
}
- (void)umLaunchOptions {
    //start umeng analyics
    UMConfigInstance.appKey = UMengAppKey;
    UMConfigInstance.channelId = UMengChannelId;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengAppKey];
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxe9cc7c18f316ca86" appSecret:@"5801c79a326d2e95c16cec8fa566b7c5" redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106014338"/*设置QQ平台的appID*/  appSecret:@"p6lE3bSt5ljFX5HK" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2322102796"  appSecret:@"16eb737c535dc66c865b7cc4663cba78" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.absoluteString hasPrefix:@"fivesecapp://"]) {
        NSString *urlHost = url.host;
        NSString *path = url.path;
        path = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
        UIViewController *pushVC;
        if ([urlHost isEqualToString:@"feeds"]) {
            FeedDetailViewController *detailVC = [[FeedDetailViewController alloc] init];
            detailVC.feed_hash_name = path;
            pushVC = detailVC;
            
        } else if ([urlHost isEqualToString:@"circles"]) {
            if (![VTAppContext shareInstance].isOnline) {
                return YES;
            }
            QZListVC *listVC = [[QZListVC alloc] init];
            listVC.hash_name = path;
            pushVC = listVC;
        }
        pushVC.hidesBottomBarWhenPushed = YES;
        UITabBarController * rootController = (UITabBarController *)self.window.rootViewController;
        if (![rootController isKindOfClass:[UITabBarController class]]) {
            return YES;
        }
        
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
    } else {
        
    }
    return YES;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[VersionManager sharedManager] startMonitorVersion];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

@end
