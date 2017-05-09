//
//  VTTextFeild.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/18.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTTextFeild : UIView

@property (nonatomic,strong)UITextField *textField;

- (instancetype)initWithFrame:(CGRect)frame
                         icon:(UIImage *)icon
                  placeholder:(NSString *)placeholder;

@end
