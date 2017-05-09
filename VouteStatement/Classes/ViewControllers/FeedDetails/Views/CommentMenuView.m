//
//  CommentMenuView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CommentMenuView.h"

static NSInteger const menuItemTag = 101;

@interface CommentMenuView ()

@property (nonatomic,assign,readwrite)CGFloat scrollRange;


@end

@implementation CommentMenuView

- (instancetype)initWithFrame:(CGRect)frame  {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        NSArray * titles = @[@"最新评论",@"最热评论"];
        CGFloat width = 80;
        CGFloat intervalX = (self.width/2.0f - width)/2.0f;

        CGFloat height= frame.size.height - 1.5;
        self.scrollRange = SCREEN_WIDTH -2*intervalX-width;
        
        for (int i = 0; i < titles.count; i ++) {
            UIButton * menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
            menuItem.tag = menuItemTag + i;
            _currentSelectIndex =0;
            menuItem.frame = CGRectMake (i ? intervalX * 3 + width :intervalX , 0, width, height);
            [menuItem setTitle:titles[i] forState:UIControlStateNormal];
            [menuItem setTitleColor:UIRGBColor(175, 175, 175, 1) forState:UIControlStateNormal];
            [menuItem setTitleColor:UIRGBColor(38, 38, 38, 1) forState:UIControlStateSelected];
            menuItem.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            if (i  == 0) {
                menuItem.selected = YES;
                [self addSubview:self.indicator];
                self.indicator.frame = CGRectMake(menuItem.left, frame.size.height-1.5f, width, 1.5f);
            }
            [menuItem addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:menuItem];
        }
    }
    
    return self;
}

- (void)menuClicked:(UIButton *)sender {
    
    if (sender.selected) {
        
        return;
    }
    self.menuItemClick(sender.tag-menuItemTag);
    
    self.currentSelectIndex = sender.tag -menuItemTag;
}

- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex {
    
    if (currentSelectIndex != _currentSelectIndex) {
        
        UIButton * pastSelectBtn    = [self viewWithTag:_currentSelectIndex+menuItemTag];
        
        UIButton * currentSelectBtn = [self viewWithTag:currentSelectIndex+menuItemTag];
        
        _currentSelectIndex         = currentSelectIndex;
        
        pastSelectBtn.selected      = !pastSelectBtn.selected;
        currentSelectBtn.selected   = !currentSelectBtn.selected;
        
        CGRect frame = self.indicator.frame;
        
        frame.origin.x = currentSelectBtn.frame.origin.x;
        
        self.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.indicator.frame = frame;
            
        } completion:^(BOOL finished) {
            
            self.userInteractionEnabled = finished;
        }];
    }
}

#pragma mark -- setter && getter

- (UIView *)indicator {
    if (!_indicator) {
        
        _indicator = [[UIView alloc] init];
        _indicator.backgroundColor =  UIRGBColor(38, 38, 38, 1);
    }
    return _indicator;
}

@end
