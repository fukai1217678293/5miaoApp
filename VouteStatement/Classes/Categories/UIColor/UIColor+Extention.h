//
//  UIColor+Extention.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/24.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIRGBColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface UIColor (Extention)

/*!  16进制色值转换 !*/
+ (UIColor *)colorWithHexstring:(NSString *)stringToConvert;

@end
