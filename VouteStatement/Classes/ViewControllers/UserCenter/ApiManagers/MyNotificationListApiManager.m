//
//  MyNotificationListApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyNotificationListApiManager.h"

@interface MyNotificationListApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation MyNotificationListApiManager

- (instancetype)init {
    if (self = [super init]) {
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    return @"/v1/users/self/push/feeds";
}
- (NSString *)serviceType {
    return kVTServiceGDMapService;
}
- (VTAPIManagerRequestType)requestType {
    return VTAPIManagerRequestTypeGet;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSDictionary *dataDict = data[@"data"];
    if (![dataDict isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSArray *feeds = dataDict[@"feeds"];
    if (![feeds isKindOfClass:[NSArray class]]) {
        return NO;
    }
    return YES;
}


@end
