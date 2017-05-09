//
//  MyCreateFeedListApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyCreateFeedListApiManager.h"

@interface MyCreateFeedListApiManager () <VTApiManager,VTAPIManagerValidator>

@end

@implementation MyCreateFeedListApiManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    
    return @"/v1/users/self/created";
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
