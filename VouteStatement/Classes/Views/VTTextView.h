//
//  VTTextView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/20.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTTextView : UITextView

@property (nonatomic,copy)NSString *placeholder;

@property (nonatomic,assign)long limitLength;
@property (nonatomic,assign)BOOL hiddenTipLimitProgress;

@end
