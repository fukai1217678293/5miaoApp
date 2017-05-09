//
//  LoginReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/20.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LoginReformer.h"
#import "RegistApiManager.h"
#import "LoginApiManager.h"

@implementation LoginReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    if ([manager isKindOfClass:[RegistApiManager class]]) {
        NSDictionary * dataDict = data[@"data"];
        return dataDict;
    }
    else if ([manager isKindOfClass:[LoginApiManager class]]){
        NSDictionary * dataDict = data[@"data"];
        return dataDict;
    }
    return data;
}

@end
