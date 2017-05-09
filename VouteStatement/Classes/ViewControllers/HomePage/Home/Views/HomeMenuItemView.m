//
//  HomeMenuItemView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "HomeMenuItemView.h"

static NSInteger const menuItemTag = 101;

@interface HomeMenuItemView ()

@property (nonatomic,assign,readwrite)CGFloat scrollRange;

@end

@implementation HomeMenuItemView

- (instancetype)initWithFrame:(CGRect)frame  {
    
    if (self = [super initWithFrame:frame]) {
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.backgroundColor = [UIColor colorWithHexstring:@"#e1e1e1"].CGColor;
        lineLayer.frame = CGRectMake(0, frame.size.height - 1, SCREEN_WIDTH, 1);
        [self.layer addSublayer:lineLayer];
        NSArray * titles = @[@"圈子",@"发现"];
        CGFloat interval_x = 10.0f;
        CGFloat width = (SCREEN_WIDTH - 3*interval_x)/2.0f;
        CGFloat height= frame.size.height - 8;
        self.scrollRange = width+interval_x;
        for (int i = 0; i < titles.count; i ++) {
            UIButton * menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
            menuItem.tag = menuItemTag + i;
            _currentSelectIndex =0;
            menuItem.frame = CGRectMake (i ?  width + 2 *interval_x :10 , 0, width, height);
            [menuItem setTitle:titles[i] forState:UIControlStateNormal];
            [menuItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            menuItem.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
            if (i  == 0) {
                menuItem.selected = YES;
                [self addSubview:self.indicator];
                self.indicator.frame = CGRectMake(10, frame.size.height-2, width, 2);
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
        _indicator.backgroundColor = [UIColor blackColor];
    }
    return _indicator;
}

@end
