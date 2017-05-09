//
//  LimitLengthTextView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/28.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LimitLengthInputViewHeader.h"

@interface LimitLengthTextView : UITextView

@property (nonatomic,assign)int minLength;
@property (nonatomic,assign)int maxLength;
@property (nonatomic,copy)InputViewDidAchieveLimitLengthHandle limitAchieveHandle;
@property (nonatomic,copy)InputViewDidChangeTextHandle textDidChangedHandle;
@property (nonatomic,copy)NSString *placeholder;
@property (nonatomic,strong)UIImage *leftAccessoryImage;
@end
