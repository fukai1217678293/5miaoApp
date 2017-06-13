//
//  PushAliasServince.h
//  VouteStatement
//
//  Created by 付凯 on 2017/6/1.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "PushServince.h"

@interface PushAliasServince : PushServince

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias;

@end
