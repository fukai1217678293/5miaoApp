//
//  RegexValidateProxy.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/13.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "RegexValidateProxy.h"

@implementation RegexValidateProxy

/*防止空字符*/
+ (BOOL)isNullString:(id)value {
    
    if (!value) {
        
        return YES;
    }
    
    if ([value isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    if (![value isKindOfClass:[NSString class]]) {
        
        return YES;
    }
    return NO;
}

@end
