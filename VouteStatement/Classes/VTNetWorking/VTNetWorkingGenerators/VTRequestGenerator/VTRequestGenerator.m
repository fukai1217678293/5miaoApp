//
//  VTRequestGenerator.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/13.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTRequestGenerator.h"
#import <AFNetworking.h>
#import "NetWorkingConfiguration.h"
#import "VTService.h"
#import "VTServiceFactory.h"
#import "NSURLRequest+VTNetworkingMethod.h"

@interface VTRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;


@end

@implementation VTRequestGenerator

static VTRequestGenerator * _instance = nil;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!_instance) {
            
            _instance = [[VTRequestGenerator alloc] init];
        }
        
    });
    
    return _instance;
}


- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    
    NSString *urlString;
    
    VTService * service = [[VTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    urlString = [NSString stringWithFormat:@"%@%@",service.apiBaseUrl,methodName];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];

    if ([VTAppContext shareInstance].authorization) {
        [request setValue:[VTAppContext shareInstance].authorization forHTTPHeaderField:@"Authorization"];
    }
    NSMutableString * appbootString = [[NSMutableString alloc] initWithString:@"OS=iOS&"];
    [appbootString appendString:[NSString stringWithFormat:@"Release=%@&",[VTAppContext shareInstance].osVersion]];
    [appbootString appendString:[NSString stringWithFormat:@"Model=%@&",[VTAppContext shareInstance].deviceName]];
    [appbootString appendString:[NSString stringWithFormat:@"VersionCode=%@&",[VTAppContext shareInstance].appVersionCode]];
    [appbootString appendString:[NSString stringWithFormat:@"Width=%.0f&",SCREEN_WIDTH]];
    [appbootString appendString:[NSString stringWithFormat:@"Height=%.0f",SCREEN_HEIGHT]];
    [request setValue:appbootString forHTTPHeaderField:@"x-app-bt"];
    NSLog(@"%@",[VTAppContext shareInstance].uuid);
    [request setValue:[VTAppContext shareInstance].uuid forHTTPHeaderField:@"x-app-device"];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    
     VTService * service = [[VTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",service.apiBaseUrl,methodName];
    
    NSMutableURLRequest * request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    
    if ([VTAppContext shareInstance].authorization) {
        
        [request setValue:[VTAppContext shareInstance].authorization forHTTPHeaderField:@"Authorization"];
    }
    NSMutableString * appbootString = [[NSMutableString alloc] initWithString:@"OS=iOS&"];
    [appbootString appendString:[NSString stringWithFormat:@"Release=%@&",[VTAppContext shareInstance].osVersion]];
    [appbootString appendString:[NSString stringWithFormat:@"Model=%@&",[VTAppContext shareInstance].deviceName]];
    [appbootString appendString:[NSString stringWithFormat:@"VersionCode=%@&",[VTAppContext shareInstance].appVersionCode]];
    [appbootString appendString:[NSString stringWithFormat:@"Width=%.0f&",SCREEN_WIDTH]];
    [appbootString appendString:[NSString stringWithFormat:@"Height=%.0f",SCREEN_HEIGHT]];
    [request setValue:appbootString forHTTPHeaderField:@"x-app-bt"];
    [request setValue:[VTAppContext shareInstance].uuid forHTTPHeaderField:@"x-app-device"];
    request.requestParams = requestParams;
    
    return request;
}

- (NSURLRequest *)generateDeleteRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    VTService * service = [[VTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",service.apiBaseUrl,methodName];
    NSMutableURLRequest * request = [self.httpRequestSerializer requestWithMethod:@"DELETE" URLString:urlString parameters:requestParams error:NULL];
    if ([VTAppContext shareInstance].authorization) {
        
        [request setValue:[VTAppContext shareInstance].authorization forHTTPHeaderField:@"Authorization"];
    }
    NSMutableString * appbootString = [[NSMutableString alloc] initWithString:@"OS=iOS&"];
    [appbootString appendString:[NSString stringWithFormat:@"Release=%@&",[VTAppContext shareInstance].osVersion]];
    [appbootString appendString:[NSString stringWithFormat:@"Model=%@&",[VTAppContext shareInstance].deviceName]];
    [appbootString appendString:[NSString stringWithFormat:@"VersionCode=%@&",[VTAppContext shareInstance].appVersionCode]];
    [appbootString appendString:[NSString stringWithFormat:@"Width=%.0f&",SCREEN_WIDTH]];
    [appbootString appendString:[NSString stringWithFormat:@"Height=%.0f",SCREEN_HEIGHT]];
    [request setValue:appbootString forHTTPHeaderField:@"x-app-bt"];
    [request setValue:[VTAppContext shareInstance].uuid forHTTPHeaderField:@"x-app-device"];
    
    request.requestParams = requestParams;
    
    return request;
    
}
- (NSURLRequest *)generatePatchRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    
    VTService * service = [[VTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];

    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",service.apiBaseUrl,methodName];
    
    NSMutableURLRequest * request = [self.httpRequestSerializer requestWithMethod:@"PATCH" URLString:urlString parameters:requestParams error:NULL];
    
    if ([VTAppContext shareInstance].authorization) {
        
        [request setValue:[VTAppContext shareInstance].authorization forHTTPHeaderField:@"Authorization"];
    }
    NSMutableString * appbootString = [[NSMutableString alloc] initWithString:@"OS=iOS&"];
    [appbootString appendString:[NSString stringWithFormat:@"Release=%@&",[VTAppContext shareInstance].osVersion]];
    [appbootString appendString:[NSString stringWithFormat:@"Model=%@&",[VTAppContext shareInstance].deviceName]];
    [appbootString appendString:[NSString stringWithFormat:@"VersionCode=%@&",[VTAppContext shareInstance].appVersionCode]];
    [appbootString appendString:[NSString stringWithFormat:@"Width=%.0f&",SCREEN_WIDTH]];
    [appbootString appendString:[NSString stringWithFormat:@"Height=%.0f",SCREEN_HEIGHT]];
    [request setValue:appbootString forHTTPHeaderField:@"x-app-bt"];
    [request setValue:[VTAppContext shareInstance].uuid forHTTPHeaderField:@"x-app-device"];
    request.requestParams = requestParams;
    
    return request;
}

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = request_timeoutInterval;
        _httpRequestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData | NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    }
    return _httpRequestSerializer;
}

@end
