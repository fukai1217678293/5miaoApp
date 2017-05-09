//
//  CommentListApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/29.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CommentListApiManager.h"

@interface CommentListApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,copy)NSString *hash_name;

@end
@implementation CommentListApiManager

- (instancetype)initWithHash:(NSString *)hash {
    if (self = [self init]) {
        self.hash_name = hash;
    }
    return self;
}
- (instancetype)init {
    
    if (self = [super init]) {
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    NSString * name = [NSString stringWithFormat:@"/v1/feeds/%@/comments",self.hash_name];
    return name;
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
    NSArray * array = dataDict[@"comments"];
    if (![array isKindOfClass:[NSArray class]]) {
        return NO;
    }
    return YES;
}


@end
