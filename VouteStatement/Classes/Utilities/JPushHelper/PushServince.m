//
//  PushServince.m
//  VouteStatement
//
//  Created by 付凯 on 2017/6/1.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "PushServince.h"
#import "PushTagServince.h"
#import "PushAliasServince.h"
#import "JPUSHService.h"

@implementation PushServince

- (void)tagsAliasCallback:(int)iResCode tags:(NSString *)tags alias:(NSString*)alias {
    
}

- (void)setTags:(NSSet *)tags {
    _tags = tags;
    [JPUSHService setTags:tags callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[PushTagServince new]];
}
- (void)setAlias:(NSString *)alias {
    _alias = alias;
    [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[PushAliasServince new]];
}
@end
