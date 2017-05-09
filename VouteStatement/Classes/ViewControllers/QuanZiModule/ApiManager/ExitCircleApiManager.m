//
//  ExitCircleApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "ExitCircleApiManager.h"

@interface ExitCircleApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,copy)NSString *circle_hash;

@end

@implementation ExitCircleApiManager

- (instancetype)initWithCircleHash:(NSString *)hashString {
    if (self = [super init]) {
        self.validatorDelegate = self;
        self.circle_hash = hashString;
    }
    return self;
}
- (NSString *)methodName {
    return [NSString stringWithFormat:@"/v1/users/self/circles/%@",self.circle_hash];
}
- (NSString *)serviceType {
    return kVTServiceGDMapService;
}
- (VTAPIManagerRequestType)requestType {
    return VTAPIManagerRequestTypeDelete;
}

- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}



@end
