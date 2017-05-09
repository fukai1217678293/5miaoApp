//
//  VTApiProxy.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/12.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTApiProxy.h"
#import <AFNetworking.h>
#import "VTApiProxyHeader.h"
#import "RegexValidateProxy.h"
#import "NSURLRequest+VTNetworkingMethod.h"

@interface VTApiProxy ()

@property (nonatomic,strong)AFHTTPSessionManager *manager;

@property (nonatomic,strong)NSMutableDictionary * dataTaskOperations;

@end

@implementation VTApiProxy


static VTApiProxy * _instance = nil;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!_instance) {
            
            _instance = [[VTApiProxy alloc] init];
        }
    });
    
    return _instance;
}
#pragma mark -- GET
- (NSNumber *)callGETWithServiceIdentifer:(NSString *)serviceIdentifer params:(NSDictionary *)params
               methodName:(NSString *)methodName
                  success:(VTApiSuccessCallback)success
                     fail:(VTApiFailCallback)fail {
    
    NSURLRequest * request = [[VTRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:serviceIdentifer requestParams:params methodName:methodName];
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@?",base_interface_url,methodName];
//    
//    for (NSString * key in params.allKeys) {
//        
//        NSString * value = [params valueForKey:key];
//        
//        value = [RegexValidateProxy isNullString:value] ? @"" : value;
//        
//        urlString = [NSString stringWithFormat:@"%@%@=%@",urlString,key,value];
//    }
//    
//    [[VTApiProxy sharedInstance].manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//       
//    }];
    
    
    return [[VTApiProxy sharedInstance] callApiWithRequest:request serviceIdentifier:serviceIdentifer successCall:success failCall:fail];

}
#pragma mark -- POST
- (NSNumber *)callPOSTWithServiceIdentifer:(NSString *)serviceIdentifer params:(NSDictionary *)params methodName:(NSString *)methodName success:(VTApiSuccessCallback)success fail:(VTApiFailCallback)fail {
    
    NSURLRequest * request = [[VTRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:serviceIdentifer requestParams:params methodName:methodName];
    
    NSNumber * requestId = [[VTApiProxy sharedInstance] callApiWithRequest:request serviceIdentifier:serviceIdentifer successCall:success failCall:fail];
    
    return requestId;
}
#pragma mark -- PATCH
- (NSNumber *)callPATCHWithServiceIdentifer:(NSString *)serviceIdentifer params:(NSDictionary *)params
                                 methodName:(NSString *)methodName
                                    success:(VTApiSuccessCallback)success
                                       fail:(VTApiFailCallback)fail {
    
    NSURLRequest * request = [[VTRequestGenerator sharedInstance] generatePatchRequestWithServiceIdentifier:serviceIdentifer requestParams:params methodName:methodName];
    
    NSNumber * requestId = [[VTApiProxy sharedInstance] callApiWithRequest:request serviceIdentifier:serviceIdentifer successCall:success failCall:fail];
    
    return requestId;
    
}
- (NSNumber *)callDELETEWithServiceIdentifer:(NSString *)serviceIdentifer params:(NSDictionary *)params
                                  methodName:(NSString *)methodName
                                     success:(VTApiSuccessCallback)success
                                        fail:(VTApiFailCallback)fail {
    NSURLRequest * request = [[VTRequestGenerator sharedInstance] generateDeleteRequestWithServiceIdentifier:serviceIdentifer requestParams:params methodName:methodName];
    
    NSNumber * requestId = [[VTApiProxy sharedInstance] callApiWithRequest:request serviceIdentifier:serviceIdentifer successCall:success failCall:fail];
    
    return requestId;
    
}
- (void)cancelRequestWithRequestId:(NSNumber *)requestId {
    
    NSURLSessionDataTask * dataTask = self.dataTaskOperations[requestId];
    
    [dataTask cancel];
    
    [self.dataTaskOperations removeObjectForKey:requestId];
}
- (void)cancelRequestList:(NSArray *)requestList {
    
    for (NSNumber *requestId in requestList) {
        
        [self cancelRequestWithRequestId:requestId];
    }
}

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request  serviceIdentifier:(NSString *)serviceIdentifier successCall:(VTApiSuccessCallback)success failCall:(VTApiFailCallback)fail {
    
    if ([serviceIdentifier isEqualToString:kVTServiceGDMapService]) {
        return [self callMapApiWithRequest:request successCallback:success failCallback:fail];
    }
    else {
        
        return [self callUploadApiRequest:request successCallback:success failCallback:fail];
    }
    
}

- (NSNumber *)callMapApiWithRequest:(NSURLRequest *)request successCallback:(VTApiSuccessCallback)success failCallback:(VTApiFailCallback)fail {
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    
    dataTask = [[VTApiProxy sharedInstance].manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dataTaskOperations removeObjectForKey:requestID];
        
        if (responseObject) {
            
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",obj);

        }
        
        NSLog(@"ssss");
        
        //        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (error) {
            
            VTURLResponse *vTResponse = [[VTURLResponse alloc] initWithResponseString:responseString  request:request requestId:[requestID integerValue] responseData:responseData error:error];
            fail?fail(vTResponse):nil;
        } else {
            // 检查http response是否成立。
            
            VTURLResponse *vTResponse = [[VTURLResponse alloc] initWithResponseString:responseString request:request requestId:[requestID integerValue] responseData:responseData status:VTURLResponseStatusSuccess];
            
            success?success(vTResponse):nil;
        }
        
    }];
    
    NSNumber * requestId =  @([dataTask taskIdentifier]);
    
    self.dataTaskOperations[requestId] = dataTask;
    
    [dataTask resume];
    
    return requestId;
    
}
- (NSNumber *)callUploadApiRequest:(NSURLRequest *)request successCallback:(VTApiSuccessCallback)success failCallback:(VTApiFailCallback)fail {
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    UIImage * uploadImage ;
    
    if (request.requestParams) {
        
        uploadImage = request.requestParams[@"image"];
    }
    
    
    dataTask = [[VTApiProxy sharedInstance].manager POST:request.URL.absoluteString parameters:request.requestParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        NSData *data = UIImageJPEGRepresentation(uploadImage, 0.3);
        
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:@"wsfile" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dataTaskOperations removeObjectForKey:requestID];
        
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"ssss");
        
        //        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
//        if (error) {
//            
//           
//        } else {
//            // 检查http response是否成立。
        
        VTURLResponse *vTResponse = [[VTURLResponse alloc] initWithResponseString:responseString request:request requestId:[requestID integerValue] responseData:responseData status:VTURLResponseStatusSuccess];
        
        success?success(vTResponse):nil;

        //        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dataTaskOperations removeObjectForKey:requestID];

        NSString *responseString = [[NSString alloc] initWithData:nil encoding:NSUTF8StringEncoding];

        VTURLResponse *vTResponse = [[VTURLResponse alloc] initWithResponseString:responseString  request:request requestId:[requestID integerValue] responseData:nil error:error];
        fail?fail(vTResponse):nil;
    }];
 
//    dataTask = [[VTApiProxy sharedInstance].manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//        
//    }];
    
    NSNumber * requestId =  @([dataTask taskIdentifier]);
    
    self.dataTaskOperations[requestId] = dataTask;
    
    [dataTask resume];
    
    return requestId;
    
}
#pragma mark -- getter

- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
        
//        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
//        _manager.requestSerializer.timeoutInterval = request_timeoutInterval;
        
//        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData     | NSURLRequestReloadIgnoringLocalAndRemoteCacheData;

        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        _manager.securityPolicy.validatesDomainName = NO;

        
//        _manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}


- (NSMutableDictionary *)dataTaskOperations {
    
    if (!_dataTaskOperations) {
        
        _dataTaskOperations = [[NSMutableDictionary alloc] init];
        
    }
    return _dataTaskOperations;
}

@end
