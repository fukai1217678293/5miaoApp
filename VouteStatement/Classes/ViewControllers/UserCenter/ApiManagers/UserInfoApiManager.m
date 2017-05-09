//
//  UserInfoApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "UserInfoApiManager.h"

@interface UserInfoApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation UserInfoApiManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    return @"/v1/users/self";
}
- (VTAPIManagerRequestType)requestType {
    
    return VTAPIManagerRequestTypeGet;
}
- (NSString *)serviceType {
    
    return kVTServiceGDMapService;
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
