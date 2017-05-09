//
//  CommonDefineConfigurations.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#ifndef CommonDefineConfigurations_h
#define CommonDefineConfigurations_h

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define KeyWindow                UIWindow * window = [UIApplication sharedApplication].delegate.window;

#define WEAKSELF                __weak typeof(self) weakSelf = self

//#define RSA_PUBLIC_KEY          @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDpByYAMyB1+ScfLk2CEEyZcfWZSF244pa0ono4W1GdJFnHTZfVk1QN3JKYpJsnW2VKZr6ZhgjxAWklOgQzajPcMR0zLdfNQvPoAM6Ttldz4tD1XJPdY8jtvjF2h66/FudCsnkDyWiR4i32LzujDd0CCN7dcm2KfJlaWfvIBvV/7QIDAQAB-----END PUBLIC KEY-----"
#define RSA_PUBLIC_KEY  @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDpByYAMyB1+ScfLk2CEEyZcfWZSF244pa0ono4W1GdJFnHTZfVk1QN3JKYpJsnW2VKZr6ZhgjxAWklOgQzajPcMR0zLdfNQvPoAM6Ttldz4tD1XJPdY8jtvjF2h66/FudCsnkDyWiR4i32LzujDd0CCN7dcm2KfJlaWfvIBvV/7QIDAQAB-----END PUBLIC KEY-----"
#define STRING_SIZE_FONT(_width_, _string_, _fsize_) [_string_ boundingRectWithSize:CGSizeMake(_width_, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_fsize_]} context:nil].size

#define STRING_SIZE(_string_,_font_) [_string_ boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_font_]} context:nil].size;

#define kBundleVersion          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#endif /* CommonDefineConfigurations_h */
