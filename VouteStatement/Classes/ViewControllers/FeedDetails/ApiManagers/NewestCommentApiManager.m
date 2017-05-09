//
//  NewestCommentApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "NewestCommentApiManager.h"

@interface NewestCommentApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,strong)NSString *fid;

@end

@implementation NewestCommentApiManager

- (instancetype)initWithFid:(NSString *)fid {
    
    if (self = [super init]) {
        self.fid = fid;
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    
    return [NSString stringWithFormat:@"/v1/feeds/%@/comments/latest",self.fid];
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
    if ([dataDict.allKeys indexOfObject:@"comments"] != NSNotFound) {
        NSArray * latestArray = dataDict[@"comments"];
        if (![latestArray isKindOfClass:[NSArray class]]) {
            return NO;
        }
    }
    return YES;
}

@end
