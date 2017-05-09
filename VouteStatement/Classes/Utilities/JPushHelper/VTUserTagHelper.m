//
//  VTUserTagHelper.m
//  VouteStatement
//
//  Created by 付凯 on 2017/5/5.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTUserTagHelper.h"
#import "AllTagApiManager.h"
#import "AllTagReformer.h"
#import "JPushHelper.h"

@interface VTUserTagHelper ()<VTAPIManagerCallBackDelegate>

@property (nonatomic,strong)AllTagApiManager *apimanager;

@end


@implementation VTUserTagHelper

static VTUserTagHelper * _obj = nil;
+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_obj) {
            _obj = [[VTUserTagHelper alloc] init];
        }
    });
    return _obj;
}

- (void)startBindNewTags{
    [self.apimanager cancelAllRequest];
    [self.apimanager loadData];
}

#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if (manager == self.apimanager) {
        NSArray *tags = [manager fetchDataWithReformer:[AllTagReformer new]];
        [[JPushHelper shareInstance] setTags:tags];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    
}

- (AllTagApiManager *)apimanager {
    if (!_apimanager) {
        _apimanager = [[AllTagApiManager alloc] init];
        _apimanager.delegate= self;
    }
    return _apimanager;
}

@end
