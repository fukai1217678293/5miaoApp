//
//  NotificationModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "NotificationModel.h"
#import <NSObject+YYModel.h>
@interface NotificationModel ()<YYModel>

@property (nonatomic,copy,readwrite)NSString *showTitle;

@end

@implementation NotificationModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"feed_hash":@"hash",
             @"ptype":@"ptype",
             @"title":@"title",
             @"unread":@"unread"};
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    NotificationModel *model = [super modelWithDictionary:dictionary];
    if ([model.ptype isEqualToString:@"vote"]) {
        model.showTitle = [NSString stringWithFormat:@"话题 %@ 有新的投票",model.title];
        model.titleRange = NSMakeRange(3, model.title.length);
    }
    else if ([model.ptype isEqualToString:@"comment"]) {
        model.showTitle = [NSString stringWithFormat:@"话题 %@ 有新评论",model.title];
        model.titleRange = NSMakeRange(3, model.title.length);
    }
    else if ([model.ptype isEqualToString:@"up"]){
        model.showTitle = [NSString stringWithFormat:@"在话题 %@ 下的评论有新的赞同",model.title];
        model.titleRange = NSMakeRange(4, model.title.length);
    }
    CGSize size = STRING_SIZE_FONT(SCREEN_WIDTH-20, model.showTitle, 17);
    model.contentHeight = size.height;
    
    return model;
}

@end
