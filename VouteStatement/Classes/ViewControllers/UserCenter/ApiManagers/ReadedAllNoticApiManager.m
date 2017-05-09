//
//  ReadedAllNoticApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "ReadedAllNoticApiManager.h"

@interface ReadedAllNoticApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation ReadedAllNoticApiManager

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
    return VTAPIManagerRequestTypeDelete;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    return YES;
}

@end
