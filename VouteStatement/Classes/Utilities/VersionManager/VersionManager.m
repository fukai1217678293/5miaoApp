//
//  VersionManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/3/10.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VersionManager.h"
#import "VersionApiManager.h"
#import "VersionReformer.h"

@interface VersionManager ()<VTAPIManagerCallBackDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)VersionApiManager *versionManager;

@property (nonatomic,copy)NSString          *updateLink;
@end

@implementation VersionManager

static VersionManager * __obj = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!__obj) {
            __obj = [[VersionManager alloc] init];
        }
    });
    return __obj;
}
- (void)startMonitorVersion {
    [self.versionManager loadData];
}
#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {

    VersionReformer * reformer = [[VersionReformer alloc] init];
    NSDictionary * responseDict = [manager fetchDataWithReformer:reformer];
    NSString * updateOption = responseDict[@"op"];
    self.updateLink = responseDict[@"link"];
    if ([updateOption isEqualToString:@"force"]) {//强制更新
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"您的版本过低,请您更新到最新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去更新", nil];
        alertView.tag = 2000;
        [alertView show];
    }
    else if ([updateOption isEqualToString:@"optional"]) {//非强制更新
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"更新提示" message:@"发现新版本,是否更新到最新版本" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"去更新", nil];
        alertView.tag = 2001;
        [alertView show];
    }
    else {//无更新
        
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {

}
#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2000) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateLink]];
    }
    else if (alertView.tag == 2001){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateLink]];
        }
    }
}

#pragma mark -- getter
- (VersionApiManager *)versionManager {
    if (!_versionManager) {
        _versionManager = [[VersionApiManager alloc] init];
        _versionManager.delegate = self;
    }
    return _versionManager;
}


@end
