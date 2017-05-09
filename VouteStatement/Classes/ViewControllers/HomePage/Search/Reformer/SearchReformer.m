//
//  SearchReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "SearchReformer.h"
#import "SearchApiManager.h"
#import "HotwordSearchApiManager.h"
#import "RecommandSearchApiManager.h"
#import "FeedExtentionModel.h"

@interface SearchReformer ()


@end

@implementation SearchReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data
{
    
    if ([manager isKindOfClass:[SearchApiManager class]]) {
        NSDictionary *dataDict      = data[@"data"];
        NSArray      *resultArray   = dataDict[@"record"];
        NSMutableArray *dataSource  = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * dict in resultArray) {
            FeedExtentionModel * feed = [[FeedExtentionModel alloc]initWithDictionary:dict];
            [dataSource addObject:feed];
        }
        return dataSource;
    }
    else if ([manager isKindOfClass:[HotwordSearchApiManager class]]){
        
        NSDictionary * dataDict = data[@"data"];
        
        NSArray *hotwords       = dataDict[@"hw"];
        
        return hotwords;
    }
    else if ([manager isKindOfClass:[RecommandSearchApiManager class]]){
        
        NSDictionary * dataDict = data[@"data"];
        
        NSArray *feeds       = dataDict[@"feeds"];
        
        return feeds;
    }
    
    NSLog(@"%@",data);
    return data;
}

@end
