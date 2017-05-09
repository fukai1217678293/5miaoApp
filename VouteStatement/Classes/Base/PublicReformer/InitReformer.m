//
//  InitReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/3/9.
//  Copyright © 2017年 韫安. All rights reserved.
//

NSString * const initReformerDataLaunchImageURLStringKey = @"initReformerDataLaunchImageURLStringKey";
NSString * const initReformerDataRSAPublickeyKey = @"initReformerDataRSAPublickeyKey";

#import "InitReformer.h"

@implementation InitReformer

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    NSDictionary *dataDict = data[@"data"];
    NSDictionary *bootDict = dataDict[@"boot"];
    return @{initReformerDataLaunchImageURLStringKey:bootDict[@"pic"],
             initReformerDataRSAPublickeyKey        :dataDict[@"public_key"]};
}

@end
