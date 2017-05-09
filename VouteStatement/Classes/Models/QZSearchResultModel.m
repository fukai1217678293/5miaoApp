//
//  QZSearchResultModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/29.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZSearchResultModel.h"
#import <NSObject+YYModel.h>

@interface QZSearchResultModel ()<YYModel>

@end

@implementation QZSearchResultModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"hash_name":@"hash",
             @"circle_name":@"circle_name"};
}
@end
