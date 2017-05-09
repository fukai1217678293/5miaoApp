//
//  VTTabbarControllerConfig.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"

@interface VTTabbarControllerConfig : NSObject

@property (nonatomic,strong)BaseTabBarController * rootController;

@property (nonatomic,assign)BOOL haveRedPointTip;

@end
