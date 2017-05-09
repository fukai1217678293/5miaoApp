//
//  NotificationManager.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString * const NotificationManagerDidReceiveNewData;

@interface NotificationManager : NSObject

+ (instancetype)sharedManager;

- (void)startMonitoring;

- (void)stopMonitoring;

@end
