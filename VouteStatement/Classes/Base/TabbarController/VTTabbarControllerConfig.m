//
//  VTTabbarControllerConfig.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTTabbarControllerConfig.h"
#import "BaseNavigationController.h"
#import "TabbarConfigHeader.h"
#import "HomePageVC.h"
#import "FeedVC.h"
#import "UserCenterVC.h"
#import "PublishNewFeedVC.h"

@interface VTTabbarControllerConfig ()

@end

@implementation VTTabbarControllerConfig

- (void)setHaveRedPointTip:(BOOL)haveRedPointTip {
    if (haveRedPointTip != _haveRedPointTip) {
        _haveRedPointTip = haveRedPointTip;
        self.rootController.showRedPointTip = haveRedPointTip;
    }
}

- (BaseTabBarController *)rootController {
    
    if (!_rootController) {
        
        _rootController = [[BaseTabBarController alloc] init];
        
        
        BaseNavigationController * homePageItemNav = [[BaseNavigationController alloc] initWithRootViewController:[HomePageVC new]];
        
        BaseNavigationController * feedItemNav = [[BaseNavigationController alloc] initWithRootViewController:[PublishNewFeedVC new]];
        
        BaseNavigationController * userCenterItemNav = [[BaseNavigationController alloc] initWithRootViewController:[UserCenterVC new]];
        
        _rootController.viewControllers = @[homePageItemNav,feedItemNav,userCenterItemNav];
        
        _rootController.tabBarItemsAttributes = [self getTabBarItemsAttributes];
        
    }
    
    return _rootController;
}



- (NSArray *)getTabBarItemsAttributes {
    
    NSDictionary * firstItemAttrDict = @{TabBarItemTitle:kThemeTabarFirstItemTitle,
                                         TabBarItemImage:kThemeTabarFirstItem_normalImageName,
                                         TabBarItemSelectedImage:kThemeTabarFirstItem_selectedImageName};

    NSDictionary * secondItemAttrDict = @{TabBarItemTitle:kThemeTabarSecondItemTitle,
                                          TabBarItemImage:kThemeTabarSecondItem_normalImageName,
                                          TabBarItemSelectedImage:kThemeTabarSecondItem_selectedImageName};

    NSDictionary * thirdItemAttrDict = @{TabBarItemTitle:kThemeTabarThirdItemTitle,
                                         TabBarItemImage:kThemeTabarThirdItem_normalImageName,
                                         TabBarItemSelectedImage:kThemeTabarThirdItem_selectedImageName};

    return @[firstItemAttrDict,secondItemAttrDict,thirdItemAttrDict];
}


@end
