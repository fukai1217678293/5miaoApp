//
//  MessageApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/18.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MessageApiManager.h"

@interface MessageApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation MessageApiManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
    
}

- (NSString *)methodName {
    
    return @"/v1/robot/sms";
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
