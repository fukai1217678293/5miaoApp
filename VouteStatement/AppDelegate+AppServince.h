//
//  AppDelegate+AppServince.h
//  VouteStatement
//
//  Created by 付凯 on 2017/3/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"

@interface AppDelegate (AppServince)<JPUSHRegisterDelegate>

- (void)launchServinceOption:(NSDictionary *)launchOption;

@end
