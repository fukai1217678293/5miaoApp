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
        NSString *text = self.text;
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
        if (!position){
            //---字符处理
            if (text.length > _maxLimit){
                //中文和emoj表情存在问题，需要对此进行处理
                NSRange range;
                NSUInteger inputLength = 0;
                for(int i=0; i < text.length && inputLength <= _maxLimit; i += range.length) {
                    range = [self.text rangeOfComposedCharacterSequenceAtIndex:i];
                    inputLength += [text substringWithRange:range].length;
                    if (inputLength > _maxLimit) {
                        NSString* newText = [text substringWithRange:NSMakeRange(0, range.location)];
                        self.text = newText;
                    }
                }
            }
        }
        if (self.textDidChangedHandle) {
            self.textDidChangedHandle(self,self.text);
        }
    }
}
- (void)setMaxLimit:(int)maxLimit {
    _maxLimit = maxLimit;
}
//#pragma mark - Notification Method
//-(void)textFieldEditChanged:(NSNotification *)obj
//{
//    UITextField *textField = (UITextField *)obj.object;
//    NSString *toBeString = textField.text;
//    NSString *lang = [textField.textInputMode primaryLanguage];
//    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
//    {
//        //获取高亮部分
//        UITextRange *selectedRange = [textField markedTextRange];
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position)
//        {
//            if (toBeString.length > _maxLimit)
//            {
//                textField.text = [toBeString substringToIndex:_maxLimit];
//            }
//        }
//        
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else
//    {
//        if (toBeString.length > _maxLimit)
//        {
//            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maxLimit];
//            if (rangeIndex.length == 1)
//            {
//                textField.text = [toBeString substringToIndex:_maxLimit];
//            }
//            else
//            {
//                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxLimit)];
//                textField.text = [toBeString substringWithRange:rangeRange];
//            }
//        }
//    }
//}
#pragma mark -- UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (![NSString isBlankString:string]) {
//        if ( string.length + textField.text.length >_maxLimit) {
//            return NO;
//        }
//    }
//    if (![string isEqualToString:@""] && (textField.text.length >= _maxLimit)) {
//        if (self.limitAchieveHandle) {
//            self.limitAchieveHandle(self);
//        }
//        return NO;
//    }
//    return YES;
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
