//
//  NSString+Util.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

//判断是否是空白字符串（含字符串为nil，NULL，NSNull，空格换行几种情况）
+ (BOOL)isBlankString:(id)string;
//判断是否为正确的手机号
+ (BOOL)isValidateMobile:(NSString *)mobileString;

@end
