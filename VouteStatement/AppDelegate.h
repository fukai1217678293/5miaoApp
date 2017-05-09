//
//  AppDelegate.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/10.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTTabbarControllerConfig.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong)VTTabbarControllerConfig *rootTabbarConfig;

- (void)pushToFeedVCWithRemoteInfo:(NSDictionary *)remoteInfo;
@end

