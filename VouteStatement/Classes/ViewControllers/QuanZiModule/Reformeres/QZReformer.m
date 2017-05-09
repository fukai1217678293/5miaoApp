//
//  QZReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZReformer.h"
#import "QZInfoApiManager.h"

#import "QZInformationModel.h"
#import <NSObject+YYModel.h>
@interface QZReformer ()

@end

@implementation QZReformer
- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    if ([manager isKindOfClass:[QZInfoApiManager class]]) {
        NSDictionary *dataDict = data[@"data"][@"circle"];
        return [QZInformationModel modelWithDictionary:dataDict];
    }
    return data;
}
@end
