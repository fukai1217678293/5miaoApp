//
//  QZInfoApiManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZInfoApiManager.h"

@interface QZInfoApiManager ()<VTApiManager,VTAPIManagerValidator>

@property (nonatomic,copy)NSString *hashString;

@end

@implementation QZInfoApiManager

- (instancetype)initWithHash:(NSString *)hash {
    if (self = [super init]) {
        self.hashString = hash;
        self.validatorDelegate = self;
    }
    return self;
}
- (NSString *)methodName {
    return [NSString stringWithFormat:@"/v1/circles/%@",self.hashString];
}
- (NSString *)serviceType {
    return kVTServiceGDMapService;
}
- (VTAPIManagerRequestType)requestType {
    return VTAPIManagerRequestTypeGet;
}

- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return YES;
}
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}
@end
