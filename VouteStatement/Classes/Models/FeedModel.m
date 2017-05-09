//
//  FeedModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/15.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedModel.h"
#import <NSObject+YYModel.h>

@interface FeedModel ()<YYModel>
@property (nonatomic,assign,readwrite)BOOL isHaveImageURL;
@property (nonatomic,assign,readwrite)CGFloat titleHeight;
@end

@implementation FeedModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"fid":@"id",
             @"all_vote":@"all_vote",
             @"live_time":@"live_time",
             @"title":@"title",
             @"pic":@"pic",
             @"feed_hash":@[@"hash",@"feed_hash"],
             @"circle_hash":@"circle_hash",
             @"circle_name":@"circle_name"};
}
- (CGFloat)titleHeight {
    if (_titleHeight >0.0001) {
        return _titleHeight;
    }
    CGSize size = STRING_SIZE_FONT(SCREEN_WIDTH -20, _title, 19);
    _titleHeight = size.height;
    return _titleHeight;
}

- (BOOL)isHaveImageURL {
    return ![NSString isBlankString:_pic];
}
- (NSString *)description {
    return [NSString stringWithFormat:@"fid = %@\nall_vote = %@\nlive_time = %@\ntitle = %@\npic = %@\nfeed_hash = %@\ncircle_hash = %@\ncircle_name = %@\n",_fid,_all_vote,_live_time,_title,_pic,_feed_hash,_circle_hash,_circle_name];
}
@end
