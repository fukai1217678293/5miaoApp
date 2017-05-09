//
//  LocalFindModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LocalFindModel.h"
#import <NSObject+YYModel.h>

@interface LocalFindModel ()<YYModel>

@property (nonatomic,assign,readwrite)BOOL isHaveImageURL;
@property (nonatomic,assign,readwrite)CGFloat titleHeight;

@end

@implementation LocalFindModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"fid":@"id",
             @"all_vote":@"all_vote",
             @"title":@"title",
             @"pic":@"pic",
             @"hash_name":@"hash",
             @"isNearby":@"nearby"};
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
@end
