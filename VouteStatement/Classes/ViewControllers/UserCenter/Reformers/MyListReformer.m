//
//  MyListReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyListReformer.h"
#import <NSObject+YYModel.h>

#import "MyCreateFeedListApiManager.h"
#import "MyJoinFeedListApiManager.h"
#import "MyQZListApiManager.h"
#import "MyNotificationListApiManager.h"
#import "NewNotificationCountApiManager.h"

#import "MyCreateListModel.h"
#import "MyJoinQZListModel.h"
#import "NotificationModel.h"
@implementation MyListReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    if ([manager isKindOfClass:[MyCreateFeedListApiManager class]] || [manager isKindOfClass:[MyJoinFeedListApiManager class]]) {
        NSArray <NSDictionary *>*feeds = data[@"data"][@"feeds"];
        NSMutableArray <MyCreateListModel *>*resultArray = [NSMutableArray arrayWithCapacity:0];
        [feeds enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [resultArray addObject:[MyCreateListModel modelWithDictionary:obj]];
        }];
        return resultArray;
    }
    else if ([manager isKindOfClass:[MyQZListApiManager class]]) {
        NSArray <NSDictionary *>*feeds = data[@"data"][@"circles"];
        NSMutableArray <MyJoinQZListModel *>*resultArray = [NSMutableArray arrayWithCapacity:0];
        [feeds enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [resultArray addObject:[MyJoinQZListModel modelWithDictionary:obj]];
        }];
        return resultArray;
    }
    else if ([manager isKindOfClass:[MyNotificationListApiManager class]]) {
        NSArray <NSDictionary *>*feeds = data[@"data"][@"feeds"];
        NSMutableArray <NotificationModel *>*resultArray = [NSMutableArray arrayWithCapacity:0];
        [feeds enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [resultArray addObject:[NotificationModel modelWithDictionary:obj]];
        }];
        return resultArray;
    }
    else if ([manager isKindOfClass:[NewNotificationCountApiManager class]]) {
        NSString *count = data[@"data"][@"count"];
        return count;
    }
    return data;
}

@end
