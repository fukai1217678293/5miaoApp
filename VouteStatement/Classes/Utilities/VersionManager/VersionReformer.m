//
//  VersionReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/3/10.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VersionReformer.h"

@implementation VersionReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    return data[@"data"];
}

@end
