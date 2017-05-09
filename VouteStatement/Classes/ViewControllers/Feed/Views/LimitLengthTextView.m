//
//  LimitLengthTextView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/28.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LimitLengthTextView.h"

@interface LimitLengthTextView ()<UITextViewDelegate>

@property (nonatomic,strong)UILabel *placeholderLabel;

@end

@implementation LimitLengthTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.placeholderLabel];
        self.maxLength = MAXFLOAT;
        self.minLength = 0;
        self.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
#pragma mark --NSNotificationCenter
- (void)textDidChanged:(NSNotification *)notic {
    if (notic.object == self) {
        if (self.textDidChangedHandle) {
            self.textDidChangedHandle(self,self.text);
        }
        self.placeholderLabel.hidden = self.text.length;
    }
}
#pragma mark --UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![text isEqualToString:@""] && textView.text.length >= self.maxLength) {
        if (self.limitAchieveHandle) {
            self.limitAchieveHandle(textView);
        }
        return NO;
    }
    return YES;
}
- (void)adjustFrame {
    CGSize size =STRING_SIZE_FONT(self.bounds.size.width, self.placeholder, [self.placeholderLabel.font pointSize]);
    CGFloat height = size.height;
    CGRect frame = self.bounds;
    frame.size.height = height;
    frame.origin.y = 8;
    self.placeholderLabel.frame = frame;
}
#pragma mark --setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self adjustFrame];
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
}
- (void)setLeftAccessoryImage:(UIImage *)leftAccessoryImage {
    _leftAccessoryImage = leftAccessoryImage;
   
}
- (void)setText:(NSString *)text {
    [super setText:text];
    self.placeholderLabel.hidden = text.length;
//    [self textDidChanged:[[NSNotification alloc] initWithName:UITextViewTextDidChangeNotification object:self userInfo:nil]];
}
#pragma mark --getter
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.textColor = [UIColor colorWithHexstring:@"cacaca"];
    }
    return _placeholderLabel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
