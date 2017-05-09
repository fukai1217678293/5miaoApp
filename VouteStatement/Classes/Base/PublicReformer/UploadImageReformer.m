//
//  UploadImageReformer.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/24.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "UploadImageReformer.h"
#import "UploadImageApiManager.h"

@implementation UploadImageReformer


- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    
    NSDictionary *dataDict = data[@"data"];
    
    NSString * urlString = dataDict[@"url"];
    
    return urlString;
}


@end
