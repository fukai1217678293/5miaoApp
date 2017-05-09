//
//  SearchApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "SearchApiManager.h"

@interface SearchApiManager ()<VTApiManager,VTAPIManagerValidator>

@end
@implementation SearchApiManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    
    return @"/v1/search";
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
    NSDictionary *dataDict      = data[@"data"];
    if (![dataDict isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSArray      *resultArray   = dataDict[@"circles"];
    if (![resultArray isKindOfClass:[NSArray class]]) {
        return NO;
    }
    return YES;
}
@end
