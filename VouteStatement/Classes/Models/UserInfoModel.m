//
//  UserInfoModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super initWithDictionary:dictionary]) {
        
        NSString * signature = dictionary[@"description"];

        self.signature = [NSString isBlankString:signature] ? @"" : signature;
    }
    return self;
}

@end
