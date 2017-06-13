//
//  JPushHelper.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "JPushHelper.h"
#import "JPUSHService.h"
#import "PushServince.h"

@interface JPushHelper ()

@property (nonatomic,strong)PushServince *pushEnity;
@end

@implementation JPushHelper

static JPushHelper * _instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !_instance ) {
            _instance = [[JPushHelper alloc] init];
        }
    });
    return  _instance;
}
- (void)setAlias:(NSString *)alias{
    _alias = alias;
    [JPUSHService setAlias:alias callbackSelector:nil object:nil];
//    [self.pushEnity setAlias:alias];
}
- (void)setTags:(NSArray *)tags {
    _tags = tags;
    NSSet *sets = [NSSet setWithArray:tags];
    [JPUSHService setTags:sets callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//    [self.pushEnity setTags:sets];
}
//vFC7XOWcAs8I35qjLp6zDQPdnlYHMt9h
//

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString*)alias {
    /*
     6001	无效的设置，tag/alias 不应参数都为 null
     6002	设置超时	建议重试
     6003	alias 字符串不合法	有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。
     6004	alias超长。最多 40个字节	中文 UTF-8 是 3 个字节
     6005	某一个 tag 字符串不合法	有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。
     6006	某一个 tag 超长。一个 tag 最多 40个字节	中文 UTF-8 是 3 个字节
     6007	tags 数量超出限制。最多 1000个	这是一台设备的限制。一个应用全局的标签数量无限制。
     6008	tag 超出总长度限制	总长度最多 7K 字节
     6011	10s内设置tag或alias大于10次	短时间内操作过于频繁
     */
    if (alias) {//设置alias
        NSString *aliasString ;
        if ([alias isKindOfClass:[NSString class]]) {
            aliasString = alias;
        }
        else {
            aliasString = [NSString stringWithFormat:@"%@",alias];
        }
        if ([alias isEqualToString:@""]) {
            NSString *errorMsg;
            if (iResCode == 0) {
                _alias = @"";
                return ;
            }
            else if (iResCode == 6001){
                
                errorMsg = @"操作有误";
            }
            else if (iResCode == 6002){
                
                errorMsg = @"退出超时,请重试";
            }
            else if (iResCode == 6003){
                
                errorMsg = @"非法操作";
            }
            else if (iResCode == 6004){
                
                errorMsg = @"操作数据有误";
            }
            else if (iResCode == 6005){
                
                errorMsg = @"操作数据异常";
            }
            else if (iResCode == 6006){
                
                errorMsg = @"退出失败";
            }
            else if (iResCode == 6007){
                
                errorMsg = @"设备限制";
            }
            else if (iResCode == 6008){
                errorMsg = @"长度限制";
            }
            else if (iResCode == 6011){
                errorMsg = @"操作过于频繁,请稍后重试";
            }
        }
        else {
            if (iResCode == 0) {
                return ;
            }
            else if (iResCode == 6011){
                [self performSelector:@selector(resetAlias) withObject:nil afterDelay:11.0f];
            }
            else {
                if (![NSString isBlankString:self.alias]) {
                    //
                    [JPUSHService setAlias:self.alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                }
            }
        }

    } else {//设置tag
        if (iResCode != 0) {
            [JPUSHService setTags:[NSSet setWithArray:self.tags] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        }
    }
}
- (void)resetAlias{
    if (![NSString isBlankString:self.alias]) {
        //
        [JPUSHService setAlias:self.alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
}


- (PushServince *)pushEnity {
    if (!_pushEnity) {
        _pushEnity = [PushServince new];
    }
    return _pushEnity;
}
@end
