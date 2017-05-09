//
//  LoginViewController.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^DismissCompletionhandle)(void);

@interface LoginViewController : BaseViewController

/*! 用于在某个行为触发登录后 登录完成继续执行该动作 !*/
@property (nonatomic,copy)DismissCompletionhandle completionhandle;

@end
