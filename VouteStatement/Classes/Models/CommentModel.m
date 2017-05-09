//
//  CommentModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/28.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CommentModel.h"
#import <NSObject+YYModel.h>

@interface CommentModel ()<YYModel>

@end

@implementation CommentModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"add_date":@"add_date",
             @"avatar":@"avatar",
             @"cid":@"cid",
             @"content":@"content",
             @"username":@"username",
             @"up":@"up",
             @"uped":@"uped",
             @"user_hash_name":@"hash"
             };
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    CommentModel *model = [super modelWithDictionary:dictionary];
    CGFloat height = STRING_SIZE_FONT(SCREEN_WIDTH-65, model.content, 15.5f).height;
    model.contentHeight = height;
    return model;
}

@end
