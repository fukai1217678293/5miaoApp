//
//  VTAppContext.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

UIKIT_EXTERN NSNotificationName const VTAppContextUserDidLoginInNotification;
UIKIT_EXTERN NSNotificationName const VTAppContextUserDidLoginOutNotification;

@interface VTAppContext : NSObject

/*! about network status !*/
@property (nonatomic,assign)BOOL isReachable;

/*! about login !*/
@property (nonatomic,assign)BOOL isOnline;

/*! about Authorization !*/
@property (nonatomic,copy)NSString *token;

/*! about Authorization !*/
@property (nonatomic,copy)NSString *token_type;

/*! user hash string, use to jpush bind alias !*/
@property (nonatomic,copy)NSString *hash_name;

/*! splicing authorization !*/
@property (nonatomic,copy)NSString *authorization;

/*! user information !*/
@property (nonatomic,copy)NSString *username;

/*! user information !*/
@property (nonatomic,copy)NSString *signature;

/*! user information !*/
@property (nonatomic,copy)NSString *headerImageUrl;

/*! user information !*/
@property (nonatomic,copy)NSString *joinedCount;

/*! user information !*/
@property (nonatomic,copy)NSString *impactCount;

/*! user information !*/
@property (nonatomic,copy)NSString *getAgreeCount;

/*! user device information !*/
@property (nonatomic,copy)NSString *osVersion;

/*! user device information !*/
@property (nonatomic,copy)NSString *deviceName;

/*! user device information !*/
@property (nonatomic,copy)NSString *appVersionCode;

/*! user device information !*/
@property (nonatomic,copy)NSString *uuid;

/*! user first open app show tip !*/
@property (nonatomic,assign)BOOL showFindDescAlert;

/*! user first open app show guide page!*/
@property (nonatomic,assign)BOOL showHelloPage;

+ (instancetype)shareInstance;

- (void)clearUserInfo ;

@end
