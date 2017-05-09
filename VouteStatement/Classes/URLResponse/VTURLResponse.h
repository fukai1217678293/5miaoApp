//
//  VTURLResponse.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/13.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkingConfiguration.h"

@interface VTURLResponse : NSObject

@property (nonatomic, assign, readonly) VTURLResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;


- (instancetype)initWithResponseString:(NSString *)responseString request:(NSURLRequest *)request requestId:(NSInteger)requestId responseData:(NSData *)responseData error:(NSError *)error;

- (instancetype)initWithResponseString:(NSString *)responseString request:(NSURLRequest *)request requestId:(NSInteger)requestId responseData:(NSData *)responseData status:(VTURLResponseStatus)status;


@end
