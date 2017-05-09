//
//  UserInfoModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/2/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

//姓名
@property (nonatomic,copy)NSString *username;

//影响
@property (nonatomic,copy)NSString *impact;

//签名
@property (nonatomic,copy)NSString *signature;

//获得点赞数
@property (nonatomic,copy)NSString *up;

//参与数
@property (nonatomic,copy)NSString *joined;

//头像
@property (nonatomic,copy)NSString *avatar;

@end
