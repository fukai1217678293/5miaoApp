//
//  HotwordSearchApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "HotwordSearchApiManager.h"

@interface HotwordSearchApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation HotwordSearchApiManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    return @"/v1/search/hw";
}
- (VTAPIManagerRequestType)requestType {
    
    return VTAPIManagerRequestTypeGet;
    
}
- (NSString *)serviceType {
    
    return kVTServiceGDMapService;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    
    return YES;
    
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    
    return YES;
}

@end
