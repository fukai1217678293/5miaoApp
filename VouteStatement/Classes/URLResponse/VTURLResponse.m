//
//  VTURLResponse.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/13.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTURLResponse.h"
#import "NSURLRequest+VTNetworkingMethod.h"

@interface VTURLResponse ()


@property (nonatomic, assign, readwrite) VTURLResponseStatus status;
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) NSInteger requestId;

@end


@implementation VTURLResponse

#pragma mark - life cycle
- (instancetype)initWithResponseString:(NSString *)responseString request:(NSURLRequest *)request requestId:(NSInteger)requestId responseData:(NSData *)responseData status:(VTURLResponseStatus)status
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.status = status;
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
    }
    return self;
}

- (instancetype)initWithResponseString:(NSString *)responseString  request:(NSURLRequest *)request requestId:(NSInteger)requestId responseData:(NSData *)responseData error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.contentString = @"";
        self.status = [self responseStatusWithError:error];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
            if (!self.content) {
                self.content = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            }
        } else {
            self.content = nil;
        }
    }
    return self;
}
#pragma mark - private methods
- (VTURLResponseStatus)responseStatusWithError:(NSError *)error{
    if (error) {
        VTURLResponseStatus result = VTURLResponseStatusErrorNoNetWork;
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result =VTURLResponseStatusErrorNoNetWork;
        }
        return result;
    } else {
        return VTURLResponseStatusSuccess;
    }
}

@end
