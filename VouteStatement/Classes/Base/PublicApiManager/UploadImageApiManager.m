//
//  UploadImageApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/24.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "UploadImageApiManager.h"

@interface UploadImageApiManager () <VTAPIManagerValidator,VTApiManager>

@end

@implementation UploadImageApiManager

- (instancetype) init {
    
    if (self = [super init]) {
        
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    return @"/job";
}

- (VTAPIManagerRequestType)requestType {
    
    return VTAPIManagerRequestTypePost;
}

- (NSString *)serviceType {
    
    return kVTServiceGDImageService;
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
