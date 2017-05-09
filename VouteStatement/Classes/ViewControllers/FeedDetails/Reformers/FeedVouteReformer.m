//
//  FeedVouteReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/6.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedVouteReformer.h"
#import "AddVouteApiManager.h"

@implementation FeedVouteReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    if ([manager isKindOfClass:[AddVouteApiManager class]]) {
        
        NSDictionary * dataDict = data[@"data"];
        return dataDict;
    }
    
    return data;
}

@end
