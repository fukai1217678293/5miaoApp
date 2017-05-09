//
//  VersionManager.h
//  VouteStatement
//
//  Created by 付凯 on 2017/3/10.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionManager : NSObject

+ (instancetype)sharedManager;


- (void)startMonitorVersion;

@end
