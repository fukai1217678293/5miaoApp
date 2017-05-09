//
//  LocalListApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LocalListApiManager.h"

@interface LocalListApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation LocalListApiManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    return @"/v1/home/discover";
}

- (VTAPIManagerRequestType)requestType {
    
    return VTAPIManagerRequestTypeGet;
}

- (NSString *)serviceType {
    
    return kVTServiceGDMapService;
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
