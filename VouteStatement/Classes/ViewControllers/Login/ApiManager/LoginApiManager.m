//
//  LoginApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/20.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LoginApiManager.h"

@interface LoginApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation LoginApiManager

- (instancetype)init {
    if (self = [super init]) {
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)serviceType {
    return kVTServiceGDMapService;
}

- (NSString *)methodName {
    return @"/v1/oauth/token";
}
- (VTAPIManagerRequestType)requestType {
    return VTAPIManagerRequestTypePost;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSDictionary * dataDict = data[@"data"];
    if (![dataDict isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    return YES;
}

@end
