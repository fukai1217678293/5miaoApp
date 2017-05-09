//
//  APIBaseManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/12.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "APIBaseManager.h"
#import "VTApiProxy.h"
#import "VTURLResponse.h"
#import <AFNetworking.h>
#import "VTAppContext.h"

#define APICall(REQUEST_METHOD,REQUEST_ID)                                                  \
{                                                                                           \
    __weak typeof(self) weakSelf = self;                                                    \
    REQUEST_ID = [[VTApiProxy sharedInstance] call##REQUEST_METHOD##WithServiceIdentifer:self.childClass.serviceType params:apiParams methodName:self.childClass.methodName success:^(VTURLResponse *responese) {                     \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                     \
        [strongSelf successedOnCallingAPI:responese];                                         \
    } fail:^(VTURLResponse *responese) {                                                     \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                    \
        if (responese.status == VTURLResponseStatusErrorTimeOut) { \
            [strongSelf failedOnCallingAPI:responese withErrorType:VTAPIManagerErrorTypeTimeout]; \
        }   \
        else if (responese.status == VTURLResponseStatusErrorNoNetWork){ \
             [strongSelf failedOnCallingAPI:responese withErrorType:VTAPIManagerErrorTypeNoNetWork]; \
        } \
        else { \
            [strongSelf failedOnCallingAPI:responese withErrorType:VTAPIManagerErrorTypeDefault]; \
        } \
    }];                                                                                         \
}



@interface APIBaseManager ()

@property (nonatomic,strong)NSMutableArray * requestIdList;


@property (nonatomic, readwrite) VTAPIManagerErrorType errorType;

@property (nonatomic, assign,readwrite) int statusCode;

@end

@implementation APIBaseManager

#pragma mark - life cycle

- (instancetype)init {
    
    if (self = [super init]) {
     
        _delegate = nil;
        _validatorDelegate = nil;
        _errorMessage = nil;
        _errorType = VTAPIManagerErrorTypeDefault;
        _fetchedRawData = nil;
        _paramsourceDelegate = nil;
        
        if ([self conformsToProtocol:@protocol(VTApiManager)]) {
            
            self.childClass = (id <VTApiManager>)self;
        }
        else {
            
            NSAssert(NO, @"子类必须要实现APIManager这个protocol。");

//            NSException *exception = [[NSException alloc] init];
//            @throw exception;
        }
        
    }
    
    return self;
}

#pragma mark - calling api

- (NSInteger)loadData {
    
    NSDictionary *params = [self.paramsourceDelegate paramsForApi:self];

    NSInteger requestId = [self loadDataWithParams:params];

    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSNumber * requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self.validatorDelegate manager:self isCorrectWithParamsData:apiParams]) {
        if ([self isReachable]) {
            
            switch (self.childClass.requestType) {
                case VTAPIManagerRequestTypeGet:
                    APICall(GET,requestId);
                    break;
                case VTAPIManagerRequestTypePost:
                    APICall(POST, requestId);
                    break;
                case VTAPIManagerRequestTypePut:
                    APICall(PUT, requestId);
                    break;
                case VTAPIManagerRequestTypePatch:
                    APICall(PATCH, requestId);
                    break;
                case VTAPIManagerRequestTypeDelete:
                    APICall(DELETE, requestId);
                    break;
                default:
                    break;
            }
        }
        else {
//            self.errorMessage = @"您当前的网络状态不给力~~";
            [self failedOnCallingAPI:nil withErrorType:VTAPIManagerErrorTypeNoNetWork];
        }
    }
    else {
        //给出errorMessage 具体为哪个参数验证失败 子类实现
        [self failedOnCallingAPI:nil withErrorType:VTAPIManagerErrorTypeParamsError];
    }
    return [requestId integerValue];
}

#pragma mark - api callbacks
/*
 只有当请求成功时回调这个函数 
 这个函数需要做的事情：
 1.取消缓存池中的request
 2.对本次请求返回数据做空值判断(为了以后灵活性，这里不对统一格式做判断防止日后如果接口格式改动牵一发动全身）
 3.由于与接口端有约定 所有的接口返回message与status status为0时请求才为正常返回 否则请求异常并返回错误信息
 4.对于某些接口：例如注册接口，需要根据错误码status控制不同的UI展示形式 所以这里父类添加一个只读属性statusCode供外部managerCallAPIDidFailed 代理回调
 */
- (void)successedOnCallingAPI:(VTURLResponse *)response
{
    self.response = response;
    [self removeRequestIdWithRequestID:@(response.requestId)];
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    }
    else {
        self.fetchedRawData = [response.responseData copy];
    }
    if (!response.content) {//保证本次请求数据不为空
        //这里需要给出errorMessage
        self.errorMessage = @"获取数据出错~~";
        [self failedOnCallingAPI:response withErrorType:VTAPIManagerErrorTypeNoContent];
    }
    else {
        if ([response.content[@"status"] integerValue] != 0) {
            
            self.errorMessage = response.content[@"msg"];
            self.statusCode   = [response.content[@"status"] intValue];
            [self failedOnCallingAPI:response withErrorType:VTAPIManagerErrorTypeNoContent];
        }
        else {
            
            if ([self.validatorDelegate manager:self isCorrectWithCallBackData:response.content]) {
                
                [self.delegate managerCallAPIDidSuccess:self];
                
            }
            else {
                self.errorMessage = @"获取数据出错~~";
                [self failedOnCallingAPI:response withErrorType:VTAPIManagerErrorTypeNoContent];
            }
        }
    }
}

- (void)failedOnCallingAPI:(VTURLResponse *)response withErrorType:(VTAPIManagerErrorType)errorType
{
//    self.isLoading = NO;
    self.response = response;
    if (!response) {//针对无response
        if (errorType == VTAPIManagerErrorTypeParamsError) {//errorMessage 子类给出
        }
        else if (errorType == VTAPIManagerErrorTypeNoNetWork) {
             self.errorMessage = @"您当前的网络状态不给力~~";
        }
    }
    else {
        if (errorType == VTAPIManagerErrorTypeDefault) {
            self.errorMessage = @"未知错误";
        }
        else if (errorType == VTAPIManagerErrorTypeNoContent) {//已在相应地方做过处理
            
        }
        else if (errorType == VTAPIManagerErrorTypeTimeout) {
            self.errorMessage = @"请求超时~~";
        }
        else if (errorType == VTAPIManagerErrorTypeNoNetWork) {
            self.errorMessage = @"您当前的网络状态不给力~~";
        }
    }
    /*
    if ([response.content[@"id"] isEqualToString:@"expired_access_token"]) {
        // token 失效
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserTokenInvalidNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kBSUserTokenNotificationUserInfoKeyRequestToContinue:[response.request mutableCopy],
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
    } else if ([response.content[@"id"] isEqualToString:@"illegal_access_token"]) {
        // token 无效，重新登录
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kBSUserTokenNotificationUserInfoKeyRequestToContinue:[response.request mutableCopy],
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
    } else if ([response.content[@"id"] isEqualToString:@"no_permission_for_this_api"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kBSUserTokenNotificationUserInfoKeyRequestToContinue:[response.request mutableCopy],
                                                                     kBSUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
    } else {
        // 其他错误
        self.errorType = errorType;
        [self removeRequestIdWithRequestID:response.requestId];
        if ([self beforePerformFailWithResponse:response]) {
            [self.delegate managerCallAPIDidFailed:self];
        }
        [self afterPerformFailWithResponse:response];
    }
    */
    [self removeRequestIdWithRequestID:@(response.requestId)];

    [self.delegate managerCallAPIDidFailed:self];
}



- (void)dealloc
{
    [self cancelAllRequest];
    self.requestIdList = nil;
}
#pragma mark -- public Method

- (void)cancelRequestWithRequestId:(NSNumber *)requestId {
    
    [[VTApiProxy sharedInstance] cancelRequestWithRequestId:requestId];
    
    [self removeRequestIdWithRequestID:requestId];

}
- (void)cancelAllRequest {
    
    [[VTApiProxy sharedInstance] cancelRequestList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}
- (id)fetchDataWithReformer:(id<VTAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(apiManager:reformData:)]) {
        
        resultData = [reformer apiManager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}


//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.childClass methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.childClass reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}
#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSNumber *)requestId
{
    
    if ([self.requestIdList indexOfObject:requestId] != NSNotFound) {
        
        [self.requestIdList removeObject:requestId];

    }
//    NSNumber *requestIDToRemove = nil;
//    for (NSNumber *storedRequestId in self.requestIdList) {
//        if ([storedRequestId integerValue] == requestId) {
//            requestIDToRemove = storedRequestId;
//        }
//    }
//    if (requestIDToRemove) {
//        [self.requestIdList removeObject:requestIDToRemove];
//    }
}


#pragma mark -- setter && getter

- (NSMutableArray *)requestIdList {
    
    if (!_requestIdList) {
    
        _requestIdList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _requestIdList;
}


- (BOOL)isReachable{

//    BOOL isReachability = ;
    if (![VTAppContext shareInstance].isReachable) {
        self.errorType = VTAPIManagerErrorTypeNoNetWork;
    }
    return [VTAppContext shareInstance].isReachable;
}



@end
