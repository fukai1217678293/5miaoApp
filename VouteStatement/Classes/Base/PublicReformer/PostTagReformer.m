//
//  PostTagReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/18.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "PostTagReformer.h"

@interface PostTagReformer ()

@end

@implementation PostTagReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    NSDictionary *dataDict = data[@"data"];
    
    NSString * uxtag = dataDict[@"uxtag"];
    
    return uxtag;
    
}

@end
