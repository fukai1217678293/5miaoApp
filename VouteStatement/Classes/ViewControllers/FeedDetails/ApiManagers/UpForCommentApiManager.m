//
//  UpForCommentApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "UpForCommentApiManager.h"

@interface UpForCommentApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,strong)NSString *cid;

@end

@implementation UpForCommentApiManager

- (instancetype)initWithCid:(NSString *)cid {
    if (self = [super init]) {
        self.cid = cid;
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    
    return [NSString stringWithFormat:@"/v1/comments/%@/vote",self.cid];
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
