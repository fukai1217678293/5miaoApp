//
//  JuBaoApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/3/8.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "JuBaoApiManager.h"

@interface JuBaoApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,strong)NSString *fid;

@end

@implementation JuBaoApiManager

- (instancetype)initWithFid:(NSString *)fid{
    if (self = [super init]) {
        self.validatorDelegate = self;
        self.fid = fid;
    }
    return self;
}
- (NSString *)methodName {
    return [NSString stringWithFormat:@"/v1/feeds/%@/report",self.fid];
}
- (NSString *)serviceType {
    
    return kVTServiceGDMapService;
}
- (VTAPIManagerRequestType)requestType {
    return VTAPIManagerRequestTypePost;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    NSString *reason = data[@"reason"];
    if (!reason) {
        manager.errorMessage = @"请输入举报原因";
        return NO;
    }
    if (reason.length<6) {
        manager.errorMessage = @"您输入的内容过短\n请输入6~255字举报原因";
        return NO;
    }
    if (reason.length>255) {
        manager.errorMessage = @"您输入的内容过长\n请输入6~255字举报原因";
        return NO;
    }
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return YES;
}


@end
