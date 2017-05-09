//
//  VoteContentView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VoteContentView.h"
#import <UIImageView+WebCache.h>

NSString * const VoteContentViewShowMoreContentStatusDidChangeNotificationName = @"VoteContentViewShowMoreContentStatusDidChangeNotificationName";

@interface VoteContentView ()

@property (nonatomic,strong)UIImageView *voteImageView;
@property (nonatomic,strong)UILabel     *contentLabel;
@property (nonatomic,strong)UIImageView *maskImageView;
@property (nonatomic,strong)UIButton    *moreButton;

@end

@implementation VoteContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.voteImageView];
        [self addSubview:self.contentLabel];
        //是否超过两行
    }
    return self;
}
- (void)moreContent:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:VoteContentViewShowMoreContentStatusDidChangeNotificationName object:@(sender.selected) userInfo:nil];
    self.showMoreContent = sender.selected;
}
#pragma mark -- setter
- (void)setDetailModel:(FeedDetailModel *)detailModel {
    
    _detailModel = detailModel;
    [self.voteImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.pic] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            
        }
    }];
    
    CGRect frame = self.contentLabel.frame;
    if (detailModel.contentHeight>35) {//是否超过两行
        frame.size.height = 35;
    }
    else {
        frame.size.height = self.detailModel.contentHeight;
    }
    self.contentLabel.frame =frame;
    if (detailModel.contentHeight > 35) {
        [self addSubview:self.maskImageView];
        [self addSubview:self.moreButton];
    }
    else {
        if (_maskImageView) {
            [_maskImageView removeFromSuperview];
        }
        if (_moreButton) {
            [_moreButton removeFromSuperview];
        }
    }
//    self.contentLabel.text = detailModel.content;
}
- (void)setShowMoreContent:(BOOL)showMoreContent {
    
    _showMoreContent = showMoreContent;
    CGRect frame = self.contentLabel.frame;
    if (showMoreContent) {
        frame.size.height = self.detailModel.contentHeight;
        self.contentLabel.numberOfLines = 0;
        self.maskImageView.hidden = YES;
    }
    else {
        if (!_maskImageView) {
            _maskImageView.hidden = NO;
        }
        if (self.detailModel.contentHeight>35) {//是否超过两行
            frame.size.height = 35;
        }
        else {
            frame.size.height = self.detailModel.contentHeight;
        }
        self.contentLabel.numberOfLines = 2;
    }
    self.contentLabel.frame =frame;
}
#pragma mark -- getter
- (UIImageView *)voteImageView {
    if (!_voteImageView) {
        _voteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH-20, 200)];
        _voteImageView.contentMode = UIViewContentModeScaleAspectFill;
        _voteImageView.backgroundColor = [UIColor clearColor];
    }
    return _voteImageView;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_voteImageView.left, _voteImageView.bottom+8, SCREEN_WIDTH- 2*_voteImageView.left, 0)];
        _contentLabel.numberOfLines = 2;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = UIRGBColor(208, 208, 202, 1.0f);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}
- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-200, self.width, 200)];
        _maskImageView.backgroundColor = [UIColor clearColor];
        _maskImageView.image = [UIImage imageNamed:@"icon_baise.png"];
    }
    return _maskImageView;
}
- (UIButton *)moreButton {
    
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(self.width/2.0f-30, _maskImageView.top+120, 60, 50);
        _moreButton.backgroundColor = [UIColor clearColor];
        [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:UIRGBColor(83, 83, 83, 1.0) forState:UIControlStateNormal];
        UIImage * img = [UIImage imageNamed:@"icon_gd.png"];
        [_moreButton setImage:img forState:UIControlStateNormal];
        _moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _moreButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        _moreButton.imageView.backgroundColor = [UIColor yellowColor];
//        _moreButton.titleLabel.backgroundColor = [UIColor purpleColor];
        _moreButton.selected = _showMoreContent;
        _moreButton.imageEdgeInsets = UIEdgeInsetsMake(30,20,-30,-20);
        _moreButton.titleEdgeInsets = UIEdgeInsetsMake(10, -img.size.width/2.0f, -10,img.size.width/2.0f);
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        [_moreButton addTarget:self action:@selector(moreContent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
