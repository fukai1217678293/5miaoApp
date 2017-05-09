//
//  QZInformationModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZInformationModel.h"
#import <NSObject+YYModel.h>
@interface QZInformationModel ()<YYModel>

@end

@implementation QZInformationModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"circle_name":@"name",
             @"circle_hash":@"hash",
             @"joined":@"joined",
             @"share_desc":@"share.desc",
             @"share_link":@"share.link",
             @"share_pic":@"share.pic",
             @"share_title":@"share.title"};
}

@end
