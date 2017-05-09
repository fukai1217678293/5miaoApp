//
//  MyJoinQZListModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyJoinQZListModel.h"
#import <NSObject+YYModel.h>

@interface MyJoinQZListModel ()<YYModel>

@property (nonatomic,assign,readwrite)CGFloat cellHeight;

@end

@implementation MyJoinQZListModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"circle_name":@"circle_name",
             @"hash_name":@"hash",
             @"unread":@"unread"};
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    MyJoinQZListModel *model = [super modelWithDictionary:dictionary];
    model.cellHeight = [model getCellHeight];
    return model;
}
- (CGFloat)getCellHeight {
    CGSize size = STRING_SIZE_FONT(SCREEN_WIDTH-20, self.circle_name, 17);
    return size.height+30;
}

@end
