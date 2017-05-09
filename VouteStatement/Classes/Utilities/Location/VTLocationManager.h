//
//  VTLocationManager.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * const VTLocationManagerDidUpdateCoordinate;

extern NSString * const VTLocationManagerDidReceiveErrorLocation;

typedef void (^VTLocationCallback) (CLLocationCoordinate2D coor);

typedef void (^VTLocationErrorCallback) (NSString *error);

@interface VTLocationManager : NSObject


+ (instancetype)shareInstance;


- (void)locationWithSuccessCallback:(VTLocationCallback)success
                       failCallback:(VTLocationErrorCallback)fail;
@end
