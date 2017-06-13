//
//  JPushHelper.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPushHelper : NSObject

@property (nonatomic,strong) NSString *alias;

@property (nonatomic,strong) NSArray *tags;

+ (instancetype)shareInstance;


@end
