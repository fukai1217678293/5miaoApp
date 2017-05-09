//
//  PostTagApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/18.
//  Copyright © 2017年 韫安. All rights reserved.
//

/*
#import "PostTagApiManager.h"

@interface PostTagApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation PostTagApiManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    return @"/v1/uxtag";
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
    return YES;
}


@end

 */
