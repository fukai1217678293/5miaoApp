//
//  PublishFeedModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface PublishFeedModel : NSObject

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *circle_name;

@property (nonatomic,copy)NSString *left_option;

@property (nonatomic,copy)NSString *right_option;

@property (nonatomic,copy)NSString *last_hours;

@property (nonatomic,copy)NSString *dec;

@property (nonatomic,copy)NSString *pic;

@property (nonatomic,copy)NSString *circle_hash;

@property (nonatomic,copy)NSString *lat;

@property (nonatomic,copy)NSString *lng;

@property (nonatomic,strong)UIImage *image;

+ (BOOL)checkPublishParam:(PublishFeedModel *)model presentVC:(BaseViewController *)presentVC;

+ (BOOL)checkPublishParam:(PublishFeedModel *)model ;
@end


