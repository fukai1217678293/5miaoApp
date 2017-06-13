//
//  VTAppContext.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTAppContext.h"
#import <AFNetworking.h>
#import "UIDevice+Platform.h"
#import "NotificationManager.h"

NSNotificationName const VTAppContextUserDidLoginInNotification = @"VTAppContextUserDidLoginInNotification";
NSNotificationName const VTAppContextUserDidLoginOutNotification = @"VTAppContextUserDidLoginOutNotification";

@implementation VTAppContext

@synthesize token           = _token;
@synthesize token_type      = _token_type;
@synthesize isOnline        = _isOnline;
@synthesize username        = _username;
@synthesize headerImageUrl  = _headerImageUrl;
@synthesize signature       = _signature;
@synthesize joinedCount     = _joinedCount;
@synthesize impactCount     = _impactCount;
@synthesize getAgreeCount   = _getAgreeCount;
@synthesize hash_name       = _hash_name;
@synthesize showFindDescAlert = _showFindDescAlert;
@synthesize showHelloPage   = _showHelloPage;

static VTAppContext * obj = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!obj) {
            obj = [[VTAppContext alloc] init];
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        }
    });
    return obj;
}

- (void)clearUserInfo {
    
    self.token_type     = nil;
    self.token          = nil;
    self.authorization  = nil;
    self.username       = nil;
    self.impactCount    = nil;
    self.joinedCount    = nil;
    self.getAgreeCount  = nil;
    self.headerImageUrl = nil;
    self.signature      = nil;
    self.hash_name      = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token_type"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"impactCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"getAgreeCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"joinedCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"headerImageUrl"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"signature"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hash_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:VTAppContextUserDidLoginOutNotification object:self];
}

#pragma mark -- setter
- (void)setToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _token = [token copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:VTAppContextUserDidLoginInNotification object:self];
}
- (void)setToken_type:(NSString *)token_type {
    [[NSUserDefaults standardUserDefaults] setValue:token_type forKey:@"token_tpye"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _token_type = [token_type copy];
}
- (void)setHash_name:(NSString *)hash_name {
    [[NSUserDefaults standardUserDefaults] setValue:hash_name forKey:@"hash_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _hash_name = [hash_name copy];
}
- (void)setUsername:(NSString *)username {
    
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _username = [username copy];
    
}
- (void)setSignature:(NSString *)signature {
    
    [[NSUserDefaults standardUserDefaults] setValue:signature forKey:@"signature"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _signature = [signature copy];
}
- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    
    [[NSUserDefaults standardUserDefaults] setValue:headerImageUrl forKey:@"headerImageUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _headerImageUrl = [headerImageUrl copy];
}
- (void)setJoinedCount:(NSString *)joinedCount {
    
    [[NSUserDefaults standardUserDefaults] setValue:joinedCount forKey:@"joinedCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _joinedCount = [joinedCount copy];
}
- (void)setImpactCount:(NSString *)impactCount {
    
    [[NSUserDefaults standardUserDefaults] setValue:impactCount forKey:@"impactCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _impactCount = [impactCount copy];
}
- (void)setGetAgreeCount:(NSString *)getAgreeCount {
    [[NSUserDefaults standardUserDefaults] setValue:getAgreeCount forKey:@"getAgreeCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _getAgreeCount = [getAgreeCount copy];
}
- (void)setShowFindDescAlert:(BOOL)showFindDescAlert {
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",showFindDescAlert] forKey:@"showFindDescAlert"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _showFindDescAlert = showFindDescAlert;
}
- (void)setShowHelloPage:(BOOL)showHelloPage {
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",showHelloPage] forKey:@"showHelloPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _showHelloPage = showHelloPage;
}
#pragma mark -- getter
- (NSString *)token {
    if (!_token) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    }
    return _token;
}
- (NSString *)token_type {
    if (!_token_type) {
        _token_type = [[NSUserDefaults standardUserDefaults] objectForKey:@"token_type"];
    }
    return _token_type;
}
- (NSString *)hash_name {
    if (!_hash_name) {
        _hash_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"hash_name"];
    }
    return _hash_name;
}
- (NSString *)authorization {
    
    if (!_authorization) {
        
        if (self.token) {
            
            _authorization = [NSString stringWithFormat:@"%@ %@",self.token_type,self.token];
        }
    }
    return _authorization;
}
- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}
- (BOOL)isOnline {
    
    if (self.token) {
        
        return YES;
    }
    return NO;
}
- (NSString *)username {
    
    if (!_username) {
        
        _username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    }
    return _username;
}
- (NSString *)signature {
    
    if (!_signature) {
        
        _signature = [[NSUserDefaults standardUserDefaults] valueForKey:@"signature"];
    }
    return _signature;
}

- (NSString *)headerImageUrl {
    
    if (!_headerImageUrl) {
        
        _headerImageUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"headerImageUrl"];
    }
    return _headerImageUrl;
}
- (NSString *)joinedCount {
    
    if (!_joinedCount) {
        
        _joinedCount = [[NSUserDefaults standardUserDefaults] valueForKey:@"joinedCount"];
    }
    return _joinedCount;
}
- (NSString *)impactCount {
    
    if (!_impactCount) {
        
        _impactCount = [[NSUserDefaults standardUserDefaults] valueForKey:@"impactCount"];
    }
    return _impactCount;
}
- (NSString *)getAgreeCount {
    
    if (!_getAgreeCount) {
        
        _getAgreeCount =  [[NSUserDefaults standardUserDefaults] valueForKey:@"getAgreeCount"];
    }
    return _getAgreeCount;
}
- (NSString *)deviceName {
    if (!_deviceName) {
        _deviceName = [UIDevice devicePlatForm];
    }
    return _deviceName;
}
- (NSString *)appVersionCode {
    if (!_appVersionCode) {
        NSString * version = kBundleVersion;
        version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
        _appVersionCode = version;
    }
    return _appVersionCode;
}
- (NSString *)osVersion {
    if (!_osVersion) {
        _osVersion =  [[UIDevice currentDevice] systemVersion];
    }
    return _osVersion;
}
- (NSString *)uuid {
    if (!_uuid) {
        _uuid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"];
        if (!_uuid) {
            if(NSClassFromString(@"NSUUID")) { // only available in iOS >= 6.0
                _uuid = [[NSUUID UUID] UUIDString];
            }
            else {
                CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
                CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
                CFRelease(uuidRef);
                _uuid = [((__bridge NSString *) cfuuid) copy];
                CFRelease(cfuuid);
            }
            [[NSUserDefaults standardUserDefaults] setValue:_uuid forKey:@"UUID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return _uuid;
}
- (BOOL)showFindDescAlert {
    NSString *showFindDescAlert = [[NSUserDefaults standardUserDefaults] valueForKey:@"showFindDescAlert"];
    if ([NSString isBlankString:showFindDescAlert]) {
        return YES;
    }
    if ([showFindDescAlert intValue]) {
        return NO;
    }
    return YES;
}
- (BOOL)showHelloPage {
    NSString *showHelloPage = [[NSUserDefaults standardUserDefaults] valueForKey:@"showHelloPage"];
    if ([NSString isBlankString:showHelloPage]) {
        return YES;
    }
    if ([showHelloPage intValue]) {
        return NO;
    }
    return YES;
}
@end
