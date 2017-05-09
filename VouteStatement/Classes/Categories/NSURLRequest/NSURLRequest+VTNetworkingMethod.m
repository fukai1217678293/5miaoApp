//
//  NSURLRequest+VTNetworkingMethod.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/24.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "NSURLRequest+VTNetworkingMethod.h"
#import <objc/runtime.h>

static void *VTNetworkingRequestParams;

@implementation NSURLRequest (VTNetworkingMethod)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &VTNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &VTNetworkingRequestParams);
}


@end
