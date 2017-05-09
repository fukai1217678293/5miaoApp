//
//  VTService.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTService.h"

@interface VTService ()

@property (nonatomic, strong, readwrite) NSString *apiBaseUrl;


@end

@implementation VTService

- (instancetype)init {
    
    if (self = [super init]) {
        
        if ([self conformsToProtocol:@protocol(VTServiceProtocol)]) {
            self.child = (id<VTServiceProtocol>)self;
        }
    }
    return self;
}
#pragma mark -- getter 

- (NSString *)apiBaseUrl {
    
    return self.child.serviceBaseUrl;
}
@end
