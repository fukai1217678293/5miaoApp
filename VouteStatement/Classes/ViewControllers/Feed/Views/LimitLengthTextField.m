//
//  LimitLengthTextField.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/27.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LimitLengthTextField.h"

@interface LimitLengthTextField ()<UITextFieldDelegate>

@end

@implementation LimitLengthTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.minLimit = 0;
        self.maxLimit = MAXFLOAT;
        self.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:self];
    }
    return self;
}
- (void)textFieldTextDidChanged:(NSNotification *)notic {
    if (notic.object == self) {
        if (self.textDidChangedHandle) {
            self.textDidChangedHandle(self,self.text);
        }
    }
}
- (void)setMaxLimit:(int)maxLimit {
    _maxLimit = maxLimit;
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:@""] && (textField.text.length >= _maxLimit)) {
        if (self.limitAchieveHandle) {
            self.limitAchieveHandle(self);
        }
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
