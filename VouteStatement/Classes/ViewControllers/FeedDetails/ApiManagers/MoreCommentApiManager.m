//
//  MoreCommentApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/6.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MoreCommentApiManager.h"

@interface MoreCommentApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,strong)NSString *fid;

@end

@implementation MoreCommentApiManager

- (instancetype)initWithFid:(NSString *)fid {
    
    if (self = [super init]) {
        self.fid = fid;
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    
    return [NSString stringWithFormat:@"/v1/feeds/%@/comments",self.fid];
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
    if ([dataDict.allKeys indexOfObject:@"latest"] != NSNotFound) {
        NSArray * latestArray = dataDict[@"latest"];
        if (![latestArray isKindOfClass:[NSArray class]]) {
            return NO;
        }
    }
    if ([dataDict.allKeys indexOfObject:@"hot"] != NSNotFound) {
        NSArray * hotArray = dataDict[@"hot"];
        if (![hotArray isKindOfClass:[NSArray class]]) {
            return NO;
        }
    }
    return YES;
}
@end
