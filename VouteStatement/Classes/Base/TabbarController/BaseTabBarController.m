//
//  BaseTabBarController.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseTabBarController.h"
#import "TabbarConfigHeader.h"
#import "FeedVC.h"
//#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "PublishNewFeedVC.h"
#import "RegistViewController.h"
static NSInteger const tabbarItemBaseTag = 100;


@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.delegate = self;
}

- (void)setTabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes {
    
    _tabBarItemsAttributes = tabBarItemsAttributes;
    
    for (int i = 0; i < tabBarItemsAttributes.count; i ++) {
        NSDictionary * attribute = tabBarItemsAttributes[i];
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        item.tag = tabbarItemBaseTag+i;
        [item setImage:[[UIImage imageNamed:attribute[TabBarItemImage]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:attribute[TabBarItemSelectedImage]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setTitle:attribute[TabBarItemTitle]];
    }
}
- (void)setShowRedPointTip:(BOOL)showRedPointTip {
    NSDictionary * thirdItemAttrDict;
    _showRedPointTip = showRedPointTip;
    if (showRedPointTip) {
        thirdItemAttrDict = @{TabBarItemTitle:kThemeTabarThirdItemTitle,
                              TabBarItemImage:kThemeTabarThirdItemRedPoint_normalImageName,
                              TabBarItemSelectedImage:kThemeTabarThirdItemRedPoint_selectedImageName};
    } else {
        thirdItemAttrDict = @{TabBarItemTitle:kThemeTabarThirdItemTitle,
                              TabBarItemImage:kThemeTabarThirdItem_normalImageName,
                              TabBarItemSelectedImage:kThemeTabarThirdItem_selectedImageName};
    }
    UITabBarItem *item = [self.tabBar.items objectAtIndex:2];
    item.tag = tabbarItemBaseTag+2;
    [item setImage:[[UIImage imageNamed:thirdItemAttrDict[TabBarItemImage]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setSelectedImage:[[UIImage imageNamed:thirdItemAttrDict[TabBarItemSelectedImage]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setTitle:thirdItemAttrDict[TabBarItemTitle]];
}
#pragma mark -- UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController.tabBarItem.tag == tabbarItemBaseTag +1) {
        
        UIViewController * selectViewController = tabBarController.selectedViewController;

        if (![VTAppContext shareInstance].isOnline) {
            
//            __block UITabBarController * weakTabbarController = tabBarController;
            RegistViewController * registVC =[[RegistViewController alloc] init];
            registVC.completionhandle = ^{
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    BaseNavigationController * feedNav = [[BaseNavigationController alloc] initWithRootViewController:[PublishNewFeedVC new]];
                    [selectViewController presentViewController:feedNav animated:YES completion:nil];
                });
            };
            
            UINavigationController * registNav = [[UINavigationController alloc] initWithRootViewController:registVC];
            [tabBarController presentViewController:registNav animated:YES completion:^{
                
            }];
            return NO;
        }
        BaseNavigationController * feedNav = [[BaseNavigationController alloc] initWithRootViewController:[PublishNewFeedVC new]];
        
        [selectViewController presentViewController:feedNav animated:YES completion:nil];
        
        return NO;
    }
    else if (viewController.tabBarItem.tag == tabbarItemBaseTag + 2) {
        
        if (![VTAppContext shareInstance].isOnline) {
            
            NSUInteger currentSelectedIndex = tabBarController.selectedIndex;
            
            __block UITabBarController * weakTabbarController = tabBarController;
            
            RegistViewController * registVC =[[RegistViewController alloc] init];
            registVC.completionhandle = ^{
 
                [weakTabbarController setSelectedIndex:2];
            };
            UIViewController * selectViewController = tabBarController.selectedViewController;
            
            UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:registVC];
            [selectViewController presentViewController:loginNav animated:YES completion:^{
                
            }];
            return NO;
        }
    }
    NSLog(@"%lu",(unsigned long)tabBarController.selectedIndex);
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
