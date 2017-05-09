//
//  OtherUserInfoApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "OtherUserInfoApiManager.h"

@interface OtherUserInfoApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,strong)NSString *uid;

@end

@implementation OtherUserInfoApiManager


- (instancetype)initWithUid:(NSString *)uid {
    
    if (self = [super init]) {
        
        self.uid = uid;
        self.validatorDelegate = self;
    }
    return self;
}

- (NSString *)methodName {
    
    return [NSString stringWithFormat:@"/v1/users/%@",self.uid];
}
- (NSString *)serviceType {
    
    return kVTServiceGDMapService;
}
- (VTAPIManagerRequestType)requestType {
    
    return VTAPIManagerRequestTypeGet;
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
