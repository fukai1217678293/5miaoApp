//
//  RecommandSearchApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "RecommandSearchApiManager.h"

@interface RecommandSearchApiManager ()<VTAPIManagerValidator,VTApiManager>


@end

@implementation RecommandSearchApiManager


- (instancetype)init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    return @"/v1/search/rec";
}
- (NSString *)serviceType {
    
    return kVTServiceGDMapService;
}

- (VTAPIManagerRequestType)requestType {
    
    return VTAPIManagerRequestTypeGet;
    
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSDictionary *dataDict      = data[@"data"];
    if (![dataDict isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    
    return YES;
}

@end
