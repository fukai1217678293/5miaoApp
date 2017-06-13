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

//手机部分型号判断
#define IS_WIDESCREEN_4    (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < __DBL_EPSILON__)

#define IS_WIDESCREEN_5    (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < __DBL_EPSILON__)

#define IS_WIDESCREEN_6      (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < __DBL_EPSILON__)

#define IS_WIDESCREEN_6Plus  (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < __DBL_EPSILON__)

//是否为iPhone手机
#define IS_IPHONE   ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone"] || [[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"])
#define IS_IPOD     ([[[UIDevice currentDevice] model] isEqualToString: @"iPod touch"])

#define IS_IPHONE_4     (IS_IPHONE && IS_WIDESCREEN_4)

#define IS_IPHONE_5     (IS_IPHONE && IS_WIDESCREEN_5)

#define IS_IPHONE_6     (IS_IPHONE && IS_WIDESCREEN_6)

#define IS_IPHONE_6Plus (IS_IPHONE && IS_WIDESCREEN_6Plus)


#define WEAKSELF                __weak typeof(self) weakSelf = self

#define RSA_PUBLIC_KEY  @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDpByYAMyB1+ScfLk2CEEyZcfWZSF244pa0ono4W1GdJFnHTZfVk1QN3JKYpJsnW2VKZr6ZhgjxAWklOgQzajPcMR0zLdfNQvPoAM6Ttldz4tD1XJPdY8jtvjF2h66/FudCsnkDyWiR4i32LzujDd0CCN7dcm2KfJlaWfvIBvV/7QIDAQAB-----END PUBLIC KEY-----"
#define STRING_SIZE_FONT(_width_, _string_, _fsize_) [_string_ boundingRectWithSize:CGSizeMake(_width_, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_fsize_]} context:nil].size

#define STRING_SIZE(_string_,_font_) [_string_ boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_font_]} context:nil].size;

#define kBundleVersion          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#endif /* CommonDefineConfigurations_h */
