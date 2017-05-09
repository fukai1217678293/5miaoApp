//
//  HomeListRefermer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/15.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "HomeListRefermer.h"
#import "HomeQuanZiApiManager.h"
#import "LocalListApiManager.h"
#import "QZListApiManager.h"
#import "MyCollectFeedListApiManager.h"
#import "MyJoinFeedListApiManager.h"
#import "MyCreateFeedListApiManager.h"
#import "OtherJoinedFeedListApiManager.h"
#import "LocalFindModel.h"
#import "FeedExtentionModel.h"
#import <NSObject+YYModel.h>
@implementation HomeListRefermer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    if ([manager isKindOfClass:[HomeQuanZiApiManager class]] || [manager isKindOfClass:[QZListApiManager class]]) {
        NSDictionary * dataDict = [data valueForKey:@"data"];
        NSArray  <NSDictionary *>* records = dataDict[@"feeds"];
        NSMutableArray <FeedModel *>* resultArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i <records.count ; i ++) {
            FeedModel * feed = [FeedModel modelWithDictionary:records[i]];
            [resultArray addObject:feed];
        }
        return resultArray;
    }
    else if ([manager isKindOfClass:[LocalListApiManager class]]) {
        NSDictionary * dataDict = [data valueForKey:@"data"];
        NSArray * feeds = [dataDict valueForKey:@"feeds"];
        NSMutableArray * dataSources =[NSMutableArray array];
        for (NSDictionary * dict in feeds) {
            LocalFindModel * feed = [LocalFindModel modelWithDictionary:dict];
            [dataSources addObject:feed];
        }
        return dataSources;
    }
    else if ([manager isKindOfClass:[MyCollectFeedListApiManager class]] || [manager isKindOfClass:[OtherJoinedFeedListApiManager class]]){
        NSDictionary * dataDict = data[@"data"];
        NSArray * dataArray = dataDict[@"feeds"];
        NSMutableArray * dataSources =[NSMutableArray array];
        for (NSDictionary * dict in dataArray) {
            FeedExtentionModel * feed = [[FeedExtentionModel alloc] initWithDictionary:dict];
            [dataSources addObject:feed];
        }
        return dataSources;
    }
   
    NSDictionary * dataDict = [data valueForKey:@"data"];
    
    NSArray * feeds = [dataDict valueForKey:@"feeds"];
    
    NSMutableArray * dataSources =[NSMutableArray array];
    
    for (NSDictionary * dict in feeds) {
        FeedModel * feed = [[FeedModel alloc] initWithDictionary:dict];
        [dataSources addObject:feed];
    }
    return dataSources;
}
@end
