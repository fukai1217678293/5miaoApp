//
//  LimitLengthTextField.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/27.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LimitLengthInputViewHeader.h"
@interface LimitLengthTextField : UITextField

@property (nonatomic,copy)InputViewDidAchieveLimitLengthHandle limitAchieveHandle;
@property (nonatomic,copy)InputViewDidChangeTextHandle textDidChangedHandle;
@property (nonatomic,assign)int minLimit;
@property (nonatomic,assign)int maxLimit;

@end
