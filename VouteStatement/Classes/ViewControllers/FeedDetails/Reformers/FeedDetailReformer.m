//
//  FeedDetailReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/28.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedDetailReformer.h"
#import "CommentModel.h"
#import "FeedDetailApiManager.h"
#import "FeedDetailModel.h"
#import "MoreCommentApiManager.h"
#import "NewestCommentApiManager.h"
#import "VTURLResponse.h"
#import "HotestCommentApiManager.h"
#import <NSObject+YYModel.h>
#import "CommentListApiManager.h"

@implementation FeedDetailReformer
- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    if ([manager isKindOfClass:[FeedDetailApiManager class]]) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dataDict = data[@"data"];
            FeedDetailModel * detail = [FeedDetailModel modelWithDictionary:dataDict];
            return detail;
        }
    }
    else if ([manager isKindOfClass:[CommentListApiManager class]]) {
        NSArray *comments = data[@"data"][@"comments"];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in comments) {
            CommentModel *model = [CommentModel modelWithDictionary:dict];
            [resultArray addObject:model];
        }
        return resultArray;
    }
    else if ([manager isKindOfClass:[NewestCommentApiManager class]]) {
        
    }
    else if ([manager isKindOfClass:[HotestCommentApiManager class]]) {
        
    }
    
    return data;
}


@end
