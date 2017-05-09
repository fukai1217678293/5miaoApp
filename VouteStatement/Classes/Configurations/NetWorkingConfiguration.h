//
//  NetWorkingConfiguration.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/13.
//  Copyright © 2017年 韫安. All rights reserved.
//

#ifndef NetWorkingConfiguration_h
#define NetWorkingConfiguration_h

typedef NS_ENUM (NSUInteger,VTURLResponseStatus) {
    
    VTURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的CTAPIBaseManager来决定。
    VTURLResponseStatusErrorTimeOut,
    
    VTURLResponseStatusErrorNoNetWork // 默认除了超时以外的错误都是无网络错误。
    
};

static  const NSTimeInterval request_timeoutInterval = 15.0f;

static NSString * const base_interface_url = @"https://api.anyknew.com";

static NSString * const base_image_interface_url = @"https://up.anyknew.com";

// services
extern NSString * const kVTServiceGDMapService;
extern NSString * const kVTServiceGDImageService;

#endif /* NetWorkingConfiguration_h */
