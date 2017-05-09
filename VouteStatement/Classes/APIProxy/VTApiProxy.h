//
//  VTApiProxy.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/12.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTRequestGenerator.h"
#import "VTURLResponse.h"

typedef void (^VTApiSuccessCallback) (VTURLResponse * responese);

typedef void (^VTApiFailCallback) (VTURLResponse * responese);

typedef void (^VTApiDownloadProgress) (NSProgress * downloadProgress);

@interface VTApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSNumber *)callGETWithServiceIdentifer:(NSString *)serviceIdentifer params:(NSDictionary *)params
                    methodName:(NSString *)methodName
                       success:(VTApiSuccessCallback)success
                          fail:(VTApiFailCallback)fail;

- (NSNumber *)callPOSTWithServiceIdentifer:(NSString *)serviceIdentifer params:(NSDictionary *)params
                     methodName:(NSString *)methodName
                        success:(VTApiSuccessCallback)success
                           fail:(VTApiFailCallback)fail;

- (NSNumber *)callPUTWithServiceIdentifer:(NSString *)serviceIdentifer params:(NSDictionary *)params
                    methodName:(NSString *)methodName
                       success:(VTApiSuccessCallback)success
                          fail:(VTApiFailCallback)fail;

- (NSNumber *)callPATCHWithServiceIdentifer:(NSString *)serviceIdentifer params:(NSDictionary *)params
                       methodName:(NSString *)methodName
                          success:(VTApiSuccessCallback)success
                             fail:(VTApiFailCallback)fail;

- (NSNumber *)callDELETEWithServiceIdentifer:(NSString *)serviceIdentifer params:(NSDictionary *)params
                                 methodName:(NSString *)methodName
                                    success:(VTApiSuccessCallback)success
                                       fail:(VTApiFailCallback)fail;

- (void)cancelRequestWithRequestId:(NSNumber *)requestId;


- (void)cancelRequestList:(NSArray *)requestList;

@end
