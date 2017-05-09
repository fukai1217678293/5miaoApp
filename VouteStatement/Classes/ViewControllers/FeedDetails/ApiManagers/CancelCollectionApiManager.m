//
//  CancelCollectionApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CancelCollectionApiManager.h"

@interface CancelCollectionApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,strong)NSString *fid;

@end


@implementation CancelCollectionApiManager


- (instancetype)initWithFid:(NSString *)fid {
    
    if (self = [super init]) {
        self.fid = fid;
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    
    return [NSString stringWithFormat:@"/v1/users/self/collect/%@",self.fid];
}
- (NSString *)serviceType {
    
    return kVTServiceGDMapService;
}
- (VTAPIManagerRequestType)requestType {
    return VTAPIManagerRequestTypeDelete;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return YES;
}


@end
