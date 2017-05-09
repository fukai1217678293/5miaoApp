//
//  VTTextFeild.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/18.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTTextFeild.h"

@implementation VTTextFeild

- (instancetype)initWithFrame:(CGRect)frame icon:(UIImage *)icon placeholder:(NSString *)placeholder {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView * iconImg =({
        
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 17)];
            [imageView setImage:icon];
            imageView.center = CGPointMake(imageView.centerX, frame.size.height/2.0f);
            imageView;
        });
        [self addSubview:iconImg];
        
        UITextField * inputTF = ({
           
            UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(iconImg.width+10, 0, frame.size.width-iconImg.width-10, frame.size.height-3)];
            textfield.font = [UIFont systemFontOfSize:16.0f];
            textfield.textAlignment = NSTextAlignmentLeft;
            textfield.placeholder = placeholder;
            textfield.backgroundColor = [UIColor clearColor];
            textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
            textfield;
        });
        self.textField = inputTF;
        [self addSubview:self.textField];
        
        CALayer * bottomLine = ({
            CALayer * layer = [[CALayer alloc] init];
            layer.frame     = CGRectMake(inputTF.left-5, frame.size.height-2, inputTF.width+10, 1);
            layer.backgroundColor = [UIColor lightGrayColor].CGColor;
            layer;
        });
        [self.layer addSublayer:bottomLine];
        
    }
    return self;
}

@end
