//
//  NotifyApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/3/9.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "NotifyApiManager.h"

@interface NotifyApiManager ()<VTApiManager,VTAPIManagerValidator>


@end

@implementation NotifyApiManager

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    return @"/v1/home/notify";
}

- (VTAPIManagerRequestType)requestType {
    
    return VTAPIManagerRequestTypePost;
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
