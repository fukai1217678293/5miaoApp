//
//  BaseModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/15.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"%@ has undefinedkey : %@    value : %@",[self class],key,value);
    
}

@end
