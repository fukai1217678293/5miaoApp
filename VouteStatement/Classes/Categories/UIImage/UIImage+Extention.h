//
//  UIImage+Extention.h
//  VouteStatement
//
//  Created by 付凯 on 2017/2/13.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extention)

/**
 解决上传图片自动旋转问题

 @return 返回正常图片
 */
-(UIImage *)fixOrientation ;

@end
