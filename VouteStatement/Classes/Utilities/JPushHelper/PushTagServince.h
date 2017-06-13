//
//  PushTagServince.h
//  VouteStatement
//
//  Created by 付凯 on 2017/6/1.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "PushServince.h"

@interface PushTagServince : PushServince

- (void)tagsAliasCallback:(int)iResCode tags:(NSString *)tags alias:(NSString*)alias;

@end
