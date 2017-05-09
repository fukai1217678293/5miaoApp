//
//  NSString+Util.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "NSString+Util.h"


@implementation NSString (Util)

//判断是否是空白字符串（含字符串为nil，NULL，NSNull，空格换行几种情况）
+ (BOOL)isBlankString:(id)string {
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (![string isKindOfClass:[NSString class]]) {
        string = [NSString stringWithFormat:@"%@", string];
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}
//判断是否为正确的手机号
+ (BOOL)isValidateMobile:(NSString *)mobileString {
    
    NSString *regex = @"^1(3|4|5|7|8)\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobileString];
    
    if (isMatch) {
        return YES;
    }
    
    return NO;
}
@end
