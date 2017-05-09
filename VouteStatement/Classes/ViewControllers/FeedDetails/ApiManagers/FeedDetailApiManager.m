//
//  FeedDetailApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/28.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedDetailApiManager.h"

@interface FeedDetailApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,copy)NSString *hash_name;

@end

@implementation FeedDetailApiManager

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
    
    NSString * name = [NSString stringWithFormat:@"/v1/feeds/%@",self.hash_name];
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
    return YES;
}
@end
