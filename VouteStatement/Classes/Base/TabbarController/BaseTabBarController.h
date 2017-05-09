//
//  BaseTabBarController.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController


@property (nonatomic, readwrite, copy) NSArray<NSDictionary *> *tabBarItemsAttributes;

@property (nonatomic,assign)BOOL showRedPointTip;
@end
