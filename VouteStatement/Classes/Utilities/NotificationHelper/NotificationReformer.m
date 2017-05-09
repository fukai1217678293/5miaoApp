//
//  NotificationReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "NotificationReformer.h"
#import "NotificationApiManager.h"

@implementation NotificationReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    if ([manager isKindOfClass:[NotificationApiManager class]]) {
        NSDictionary *dataDict = data[@"data"];
        return dataDict;
    }
    return data;
}

@end
