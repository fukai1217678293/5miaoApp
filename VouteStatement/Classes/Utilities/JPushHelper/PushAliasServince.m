//
//  PushAliasServince.m
//  VouteStatement
//
//  Created by 付凯 on 2017/6/1.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "PushAliasServince.h"
#import "JPUSHService.h"

@implementation PushAliasServince

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

@end
