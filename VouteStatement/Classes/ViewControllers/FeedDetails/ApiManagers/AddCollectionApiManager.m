//
//  AddCollectionApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "AddCollectionApiManager.h"

@interface AddCollectionApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,strong)NSString *fid;

@end

@implementation AddCollectionApiManager


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
    return VTAPIManagerRequestTypePost;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return YES;
}

@end
