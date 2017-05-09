//
//  AddFeedApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "AddFeedApiManager.h"

@interface AddFeedApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation AddFeedApiManager

- (instancetype)init {
    if (self = [super init]) {
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    return @"/v1/feeds";
}
- (NSString *)serviceType {
    
    
    return kVTServiceGDMapService;
}
- (VTAPIManagerRequestType)requestType {
    
    return VTAPIManagerRequestTypePost;
}

- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if (![data[@"data"] isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    return YES;
}
@end
