//
//  AddVouteApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/4.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "AddVouteApiManager.h"

@interface AddVouteApiManager ()<VTAPIManagerValidator,VTApiManager>

@property (nonatomic,copy)NSString *fid;

@end

@implementation AddVouteApiManager

- (instancetype)initWithFid:(NSString *)fid {
    
    if (self = [super init]) {
        
        self.fid = fid;
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    return [NSString stringWithFormat:@"/v1/feeds/%@/vote",self.fid];
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
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSDictionary * dataDict = data[@"data"];
    if (![dataDict isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    return YES;
}

@end
