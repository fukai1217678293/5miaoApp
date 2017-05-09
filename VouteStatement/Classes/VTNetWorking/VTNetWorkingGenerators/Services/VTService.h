//
//  VTService.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VTServiceProtocol <NSObject>

@property (nonatomic, strong, readonly) NSString *serviceBaseUrl;

@end

@class VTServiceProtocol;

@interface VTService : NSObject

@property (nonatomic, strong, readonly) NSString *apiBaseUrl;

@property (nonatomic,weak) id <VTServiceProtocol>child;

@end
