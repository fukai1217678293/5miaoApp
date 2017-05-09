//
//  VTServiceFactory.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTServiceFactory.h"

#import "GDMapService.h"
#import "GDImageService.h"
/************************************************************/

// service name list
NSString * const kVTServiceGDMapService = @"kVTServiceGDMapService";
NSString * const kVTServiceGDImageService = @"kVTServiceGDImageService";


@interface VTServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation VTServiceFactory

static VTServiceFactory *_shareInstance = nil;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareInstance) {
            _shareInstance = [[VTServiceFactory alloc] init];
        }
    });
    return _shareInstance;
}

- (VTService<VTServiceProtocol>*)serviceWithIdentifier:(NSString *)identifier {
    
    if (self.serviceStorage[identifier] == nil) {
        
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
    
}

#pragma mark - private methods
- (VTService<VTServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kVTServiceGDMapService]) {
        return [[GDMapService alloc] init];
    }
    else if ([identifier isEqualToString:kVTServiceGDImageService]) {
        return [[GDImageService alloc] init];
    }
    return nil;
}


#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}


@end

