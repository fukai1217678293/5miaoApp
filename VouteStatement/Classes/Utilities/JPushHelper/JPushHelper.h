//
//  JPushHelper.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^PushServinceSetAliasSuccessCall)(void);
typedef void(^PushServinceSetAliasErrorCall)(NSString *error);

@interface JPushHelper : NSObject

@property (nonatomic,strong) NSString *alias;

@property (nonatomic,strong) NSSet *tags;

+ (instancetype)shareInstance;

- (void)clearAlias:(NSString *)alias
     successHandle:(PushServinceSetAliasSuccessCall)successCallback
       errorHandle:(PushServinceSetAliasErrorCall)errorCallback;

@end
