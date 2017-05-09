//
//  UpdateUserInfoApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "UpdateUserInfoApiManager.h"

@interface UpdateUserInfoApiManager ()<VTApiManager,VTAPIManagerValidator>

@end

@implementation UpdateUserInfoApiManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    
    return @"/v1/users/self";
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
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    
    return YES;
}
@end
