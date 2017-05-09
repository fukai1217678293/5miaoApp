//
//  ResetPwdApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "ResetPwdApiManager.h"

@interface ResetPwdApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation ResetPwdApiManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    return @"/v1/account";
}
- (NSString *)serviceType {
    
    return kVTServiceGDMapService;
}
- (VTAPIManagerRequestType)requestType {
    
    return VTAPIManagerRequestTypePatch;
}

- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
   
    return YES;
}

@end
