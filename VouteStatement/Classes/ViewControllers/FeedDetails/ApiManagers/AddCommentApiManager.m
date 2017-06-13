//
//  AddCommentApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/6.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "AddCommentApiManager.h"

@interface AddCommentApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,strong)NSString *fid;

@end

@implementation AddCommentApiManager

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
    return VTAPIManagerRequestTypePost;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    NSString * content = data[@"content"];
    if ([NSString isBlankString:content]) {
        manager.errorMessage = @"评论内容不能为空";
        return NO;
    }
    else if (content.length < 1) {
        manager.errorMessage = @"评论内容不能为空";
        return NO;
    }
    else if ([content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 1) {
        manager.errorMessage = @"评论内容不能为空";
        return NO;
    }
    else if (content.length > 1000) {
        manager.errorMessage = @"评论内容在1000字以内";
        return NO;
    }
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return YES;
}

@end
