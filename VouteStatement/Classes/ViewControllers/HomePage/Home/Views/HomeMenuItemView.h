//
//  HomeMenuItemView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MenuItemClickCall)(NSInteger index);

@interface HomeMenuItemView : UIView

@property (nonatomic,assign)NSInteger currentSelectIndex;

@property (nonatomic,strong)UIView *indicator;

@property (nonatomic,assign,readonly)CGFloat scrollRange;

@property (nonatomic,copy)MenuItemClickCall menuItemClick;

//- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titles;

@end
