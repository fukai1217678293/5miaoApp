//
//  MyCreateListModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyCreateListModel.h"
#import <NSObject+YYModel.h>

@interface MyCreateListModel ()<YYModel>

@property (nonatomic,assign,readwrite)CGFloat titleHeight;

@end

@implementation MyCreateListModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"all_vote":@"all_vote",
             @"cid":@"cid",
             @"hash_name":@"hash",
             @"live_time":@"live_time",
             @"fid":@"id",
             @"left_option":@"left_option",
             @"left_vote":@"left_vote",
             @"right_option":@"right_option",
             @"right_vote":@"right_vote",
             @"title":@"title",
             @"side":@"side",
             @"voted":@"voted",
             @"self_vote":@"self_vote"};
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    MyCreateListModel *model = [super modelWithDictionary:dictionary];
    CGSize size = STRING_SIZE_FONT(SCREEN_WIDTH-20, model.title, 19);
    model.titleHeight = size.height;
    return model;
}

@end
