//
//  VTTextView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/20.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VTTextView.h"

@interface VTTextView ()<UITextViewDelegate>

@property (nonatomic,strong)UILabel *placeholderLabel;

@property (nonatomic,strong)UILabel *limitLengthLabel;

@end

@implementation VTTextView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.placeholderLabel];

        _limitLength = LONG_MAX;
        self.font = [UIFont systemFontOfSize:15];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:self];
        self.delegate = self;
    }
    return self;
}
#pragma mark -- NSNotificationCenter
- (void)textViewDidChangeText:(NSNotification *)notification {
    if (notification.object != self) {
        return;
    }
    if (self.text.length <=0) {
        self.placeholderLabel.hidden = NO;

    }
    else {
        self.placeholderLabel.hidden = YES;
    }
    if (_limitLengthLabel) {
        _limitLengthLabel.text = [NSString stringWithFormat:@"(%d/%ld)",(int)self.text.length,_limitLength];
    }
}
#pragma mark -- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (textView.text.length < _limitLength) {
        return YES;
    }
    return NO;
}

#pragma mark -- setter
- (void)setText:(NSString *)text {
    [super setText:text];
    NSNotification *notic = [[NSNotification alloc] initWithName:UITextViewTextDidChangeNotification object:self userInfo:nil];
    [self textViewDidChangeText:notic];
}
- (void)setLimitLength:(long)limitLength {
    _limitLength = limitLength;
    if (limitLength == LONG_MAX) {
        [_limitLengthLabel removeFromSuperview];
        _limitLengthLabel = nil;
    }
    else {
        if (!_limitLengthLabel) {
            [self addSubview:self.limitLengthLabel];
            [self bringSubviewToFront:self.limitLengthLabel];
            self.limitLengthLabel.frame = CGRectMake(self.width-90, self.height-30, 80, 25);
        }
        _limitLengthLabel.text = [NSString stringWithFormat:@"(0/%ld)",limitLength];
    }
}
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = [NSString isBlankString:placeholder] ? @"" :placeholder;
    CGRect rect = self.placeholderLabel.frame;
    CGSize size = STRING_SIZE_FONT( self.width-20, placeholder, 14);
    rect.size.height =size.height;
    self.placeholderLabel.frame = rect;
}
- (void)setHiddenTipLimitProgress:(BOOL)hiddenTipLimitProgress {
    _hiddenTipLimitProgress = hiddenTipLimitProgress;
    if (hiddenTipLimitProgress) {
        if (!_limitLengthLabel) {
            [_limitLengthLabel removeFromSuperview];
        }
    }
}

//- (void)setPlaceholder:(NSString *)placeholder {
//    
//    _placeholder = placeholder;
//    
//    if (!_placeholderLabel) {
//        
//        [self addSubview:self.placeholderLabel];
//        
//        self.placeholderLabel.frame = CGRectMake(10, 10, self.width-20, STRING_SIZE_FONT(self.width-20, placeholder, 14).height);
//    }
//    self.placeholderLabel.text = [NSString stringWithFormat:@"%@",placeholder];
//    
//}
#pragma mark -- getter

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 6, self.frame.size.width-8, 0)];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.numberOfLines = 0;
    }
    return _placeholderLabel;
}

- (UILabel *)limitLengthLabel {
    
    if (!_limitLengthLabel) {
        
        _limitLengthLabel                   = [[UILabel alloc] init];
        _limitLengthLabel.backgroundColor   = [UIColor clearColor];
        _limitLengthLabel.font              = [UIFont systemFontOfSize:10];
        _limitLengthLabel.textAlignment     = NSTextAlignmentRight;
        _limitLengthLabel.textColor         = [UIColor lightGrayColor];
        
    }
    return _limitLengthLabel;
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
