//
//  PublishFeedModel.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "PublishFeedModel.h"

@implementation PublishFeedModel

+ (BOOL)checkPublishParam:(PublishFeedModel *)model presentVC:(BaseViewController *)presentVC {
    if (!model) {
        [presentVC showMessage:@"请填写需要发布的信息" inView:presentVC.view];
        return NO;
    }
    if ([NSString isBlankString:model.title]) {
        [presentVC showMessage:@"请填写标题" inView:presentVC.view];
        return NO;
    }
    if (model.title.length < 1) {
        [presentVC showMessage:@"您输入的标题过短" inView:presentVC.view];
        return NO;
    }
    if ([model.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<1) {
        [presentVC showMessage:@"您输入的标题过短" inView:presentVC.view];
        return NO;
    }
    if (model.title.length > 50) {
        [presentVC showMessage:@"您输入的标题过长" inView:presentVC.view];
        return NO;
    }

    return YES;
}
+ (BOOL)checkPublishParam:(PublishFeedModel *)model {
    if (!model) {
        return NO;
    }
    if ([NSString isBlankString:model.title]) {
        return NO;
    }
    if (model.title.length < 1) {
        return NO;
    }
    if (model.title.length > 50) {
        return NO;
    }
    if ([model.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<1) {
        return NO;
    }
    return YES;
}
@end
