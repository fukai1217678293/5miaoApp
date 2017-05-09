//
//  PublishFeedReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/29.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "PublishFeedReformer.h"
#import <NSObject+YYModel.h>

#import "QZSearchApiManager.h"
#import "AddFeedApiManager.h"

#import "QZSearchResultModel.h"

@implementation PublishFeedReformer
- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    if ([manager isKindOfClass:[QZSearchApiManager class]]) {
        NSArray *dataList = data[@"data"][@"circles"];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in dataList) {
            QZSearchResultModel *model = [QZSearchResultModel modelWithDictionary:dict];
            [resultArray addObject:model];
        }
        return resultArray;
    }
    else if ([manager isKindOfClass:[AddFeedApiManager class]]) {
        return data[@"data"][@"hash"];
    }
    return data;
}
@end
