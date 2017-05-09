//
//  APIBaseManager.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/12.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

//对应不同的请求方法
typedef NS_ENUM (NSUInteger, VTAPIManagerRequestType){
    VTAPIManagerRequestTypeGet,
    VTAPIManagerRequestTypePost,
    VTAPIManagerRequestTypePut,
    VTAPIManagerRequestTypePatch,
    VTAPIManagerRequestTypeDelete
};
/*
 当产品要求返回数据不正确或者为空的时候显示一套UI，请求超时和网络不通的时候显示另一套UI时，使用这个enum来决定使用哪种UI
 你不应该在回调数据验证函数里面设置这些值，事实上，在任何派生的子类里面你都不应该自己设置manager的这个状态，baseManager已经帮你搞定了。
 强行修改manager的这个状态有可能会造成程序流程的改变，容易造成混乱。
 */
typedef NS_ENUM (NSUInteger, VTAPIManagerErrorType){
    VTAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    VTAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    VTAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    VTAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    VTAPIManagerErrorTypeTimeout,       //请求超时。VTAPIProxy设置的是15秒超时，具体超时时间的设置请自己去看VTAPIProxy的相关代码。
    VTAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};


@class APIBaseManager;

/*************************************************************************************************/
/*                               CTAPIManagerApiCallBackDelegate                                 */
/*************************************************************************************************/

//api回调
@protocol VTAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager;
@end


/*************************************************************************************************/
/*                                     CTAPIManagerValidator                                     */
/*************************************************************************************************/
//验证器，用于验证API的返回或者调用API的参数是否正确
/*
 使用场景：
 当我们确认一个api是否真正调用成功时，要看的不光是status，还有具体的数据内容是否为空。由于每个api中的内容对应的key都不一定一样，甚至于其数据结构也不一定一样，因此对每一个api的返回数据做判断是必要的，但又是难以组织的。
 为了解决这个问题，manager有一个自己的validator来做这些事情，一般情况下，manager的validator可以就是manager自身。
 
 1.有的时候可能多个api返回的数据内容的格式是一样的，那么他们就可以共用一个validator。
 2.有的时候api有修改，并导致了返回数据的改变。在以前要针对这个改变的数据来做验证，是需要在每一个接收api回调的地方都修改一下的。但是现在就可以只要在一个地方修改判断逻辑就可以了。
 3.有一种情况是manager调用api时使用的参数不一定是明文传递的，有可能是从某个变量或者跨越了好多层的对象中来获得参数，那么在调用api的最后一关会有一个参数验证，当参数不对时不访问api，同时自身的errorType将会变为CTAPIManagerErrorTypeParamsError。这个机制可以优化我们的app。
 
 william补充（2013-12-6）：
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 */
@protocol VTAPIManagerValidator <NSObject>
@required
/*
 所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 因为判断逻辑都在这里做掉了。
 而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
 
 父类只做了关于返回空值的判断的 对于具体API需要子类在这个方法里做相应的判断；
 例如：
 1、对于某个空字典的判断
 2、空数组取值的判断
 */
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

/*
 
 “
 william补充（2013-12-6）：
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 ”
 
 所以不要以为这个params验证不重要。当调用API的参数是来自用户输入的时候，验证是很必要的。
 当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。反正哪天要真是参数错误，QA那一关肯定过不掉。
 不过我还是建议认真写完这个参数验证，这样能够省去将来代码维护者很多的时间。
 
 补充：
 子类给出errorMessage 具体为哪个参数验证失败
 */
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end

/*************************************************************************************************/
/*                                VTAPIManagerParamSourceDelegate                                */
/*************************************************************************************************/
//让manager能够获取调用API所需要的数据
@protocol VTAPIManagerParamSource <NSObject>

@required

- (NSDictionary *)paramsForApi:(APIBaseManager *)manager;

@end

@protocol VTApiManager <NSObject>

@required

- (NSString *)methodName;

- (NSString *)serviceType;

- (VTAPIManagerRequestType)requestType;

@optional

- (NSDictionary *)reformParams:(NSDictionary *)params;

@end

/*************************************************************************************************/
/*                               CTAPIManagerCallbackDataReformer                                */
/*************************************************************************************************/
//负责重新组装API数据的对象

@protocol VTAPIManagerDataReformer <NSObject>

@required

- (id)apiManager:(APIBaseManager *)manager reformData:(NSDictionary *)data;

@end

@class VTURLResponse;

@interface APIBaseManager : NSObject

@property (nonatomic, strong) VTURLResponse *response;

@property (nonatomic, copy, readwrite) NSString *errorMessage;

@property (nonatomic, readonly) VTAPIManagerErrorType errorType;

@property (nonatomic, assign, readonly)int statusCode;

@property (nonatomic, strong, readwrite) id fetchedRawData;

@property (nonatomic,assign)BOOL isReachable;

@property (nonatomic, weak) NSObject<VTApiManager> *childClass; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic,weak) id <VTAPIManagerCallBackDelegate> delegate;

@property (nonatomic,weak) id <VTAPIManagerValidator> validatorDelegate;

@property (nonatomic,weak) id <VTAPIManagerParamSource> paramsourceDelegate;

@property (nonatomic,weak) id <VTAPIManagerDataReformer> dataReformer;

- (NSInteger)loadData;

- (id)fetchDataWithReformer:(id<VTAPIManagerDataReformer>)reformer;

- (void)cancelRequestWithRequestId:(NSNumber *)requestId;

- (void)cancelAllRequest;

@end


