//
//  UserHeaderView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/24.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

typedef void(^HeaderButtonDidClicked)(UIButton *sender);

@interface UserHeaderView : UIView

@property (nonatomic,copy)HeaderButtonDidClicked headerButtonDidClicked;

@property (nonatomic,copy)HeaderButtonDidClicked headerJoinedFeedDidClicked;

-(void)updateHeaderView:(CGPoint) offset ;

-(void)updateUserInformation:(UserInfoModel *)userModel;

@end
