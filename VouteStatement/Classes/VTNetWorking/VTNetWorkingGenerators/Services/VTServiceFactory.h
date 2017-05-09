//
//  VTServiceFactory.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTService.h"

@interface VTServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (VTService<VTServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end
