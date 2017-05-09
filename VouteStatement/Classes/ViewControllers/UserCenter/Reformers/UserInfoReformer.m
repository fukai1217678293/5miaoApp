//
//  UserInfoReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "UserInfoReformer.h"
#import "UserInfoApiManager.h"
#import "OtherUserInfoApiManager.h"
#import "UserInfoModel.h"
@implementation UserInfoReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    if ([manager isKindOfClass:[UserInfoApiManager class]]) {
        NSDictionary * dataDict = data[@"data"][@"user"];
        NSString * headerImageURLString = dataDict[@"avatar"];
        if ([NSString isBlankString:headerImageURLString]) {
            headerImageURLString = @"";
        }
        [VTAppContext shareInstance].headerImageUrl = headerImageURLString;
//        NSString * description = dataDict[@"description"];
//        
//        if ([NSString isBlankString:description]) {
//            description = @"";
//        }
//        [VTAppContext shareInstance].signature = description;
        
        NSString * username = dataDict[@"username"];
        if ([NSString isBlankString:username]) {
            username = @"";
        }
        [VTAppContext shareInstance].username = username;
        
//        NSString * join = dataDict[@"joined"];
//        if ([NSString isBlankString:join]) {
//            join = @"";
//        }
//        [VTAppContext shareInstance].joinedCount = join;
        
//        NSString * impact = dataDict[@"impact"];
//        if ([NSString isBlankString:impact]) {
//            impact = @"";
//        }
//        [VTAppContext shareInstance].impactCount = impact;
//        
//        NSString * up = dataDict[@"up"];
//        if ([NSString isBlankString:up]) {
//            up = @"";
//        }
//        [VTAppContext shareInstance].getAgreeCount = up;
        
        return dataDict;
    }
    else if ([manager isKindOfClass:[OtherUserInfoApiManager class]]) {
        NSDictionary * dataDict = data[@"data"];
        UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dataDict];
        return model;
    }
        
    return data;
}

@end
