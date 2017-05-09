//
//  AllTagReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/5/5.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "AllTagReformer.h"
#import "AllTagApiManager.h"

@implementation AllTagReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    if ([manager isKindOfClass:[AllTagApiManager class]]) {
        NSArray <NSString *> *tags = data[@"data"][@"tags"];
        return tags;
    }
    return data;
}
@end
