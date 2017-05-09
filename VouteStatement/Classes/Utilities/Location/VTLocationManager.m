//
//  VTLocationManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTLocationManager.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
NSString * const VTLocationManagerDidUpdateCoordinate = @"VTLocationManagerDidUpdateCoordinate";

NSString * const VTLocationManagerDidReceiveErrorLocation = @"VTLocationManagerDidReceiveErrorLocation";

@interface VTLocationManager ()<BMKLocationServiceDelegate,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong)CLLocationManager  *locationManager;
@property (nonatomic, strong)BMKLocationService  *bmkLocService;
@property (nonatomic, strong)BMKGeoCodeSearch   *searcher;
@property (nonatomic, copy)VTLocationCallback locationSuccessCall;
@property (nonatomic ,copy)VTLocationErrorCallback locationErrorCall;
@end

@implementation VTLocationManager

static VTLocationManager * __obj = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!__obj) {
            __obj = [[VTLocationManager alloc] init];
        }
    });
    return __obj;
}

- (void)locationWithSuccessCallback:(VTLocationCallback)success
                       failCallback:(VTLocationErrorCallback)fail {
    
    self.locationSuccessCall = success;
    self.locationErrorCall = fail;
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if(![CLLocationManager locationServicesEnabled]) {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        if (self.locationErrorCall) {
            self.locationErrorCall(@"未开启定位权限");
        }
    }
    else {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            
            [self.locationManager requestWhenInUseAuthorization];
        }
        else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        //开始定位，不断调用其代理方法
//        [self.locationManager startUpdatingLocation];
        [self.bmkLocService startUserLocationService];
        NSLog(@"start gps");
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    //是否具有定位权限
    if (status == kCLAuthorizationStatusNotDetermined ||
        status == kCLAuthorizationStatusRestricted ||
        status == kCLAuthorizationStatusDenied ) {
        if (self.locationErrorCall) {
            self.locationErrorCall (@"没有定位权限");
        }
    } else {
        //定位开始
        [self.bmkLocService startUserLocationService];
    }
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    // 2.停止定位
    [self.bmkLocService stopUserLocationService];
    // 1.获取用户位置的对象
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
//调试时使用
//    [self reverseGeoSearch:coordinate];
    if (self.locationSuccessCall) {
        self.locationSuccessCall(coordinate);
    }
}
- (void)reverseGeoSearch:(CLLocationCoordinate2D)coordinate {
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag) {
        NSLog(@"反geo检索发送成功");
    }
    else {
        NSLog(@"反geo检索发送失败");
    }
}
- (void)didFailToLocateUserWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    if (self.locationErrorCall) {
        
        self.locationErrorCall (@"获取定位失败");
    }
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    NSLog(@"当前地址为 : %@",result.address);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:result.address delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];

}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"aaaaaaaaaa");

}
#pragma mark -- getter
- (BMKLocationService *)bmkLocService {
    if (!_bmkLocService) {
        _bmkLocService = [[BMKLocationService alloc]init];
        _bmkLocService.pausesLocationUpdatesAutomatically = NO;
        _bmkLocService.desiredAccuracy = kCLLocationAccuracyBest;
        _bmkLocService.delegate = self;
    }
    return _bmkLocService;
}
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}
- (BMKGeoCodeSearch *)searcher {
    if (!_searcher) {
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}
@end
