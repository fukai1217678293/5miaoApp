//
//  HomeFindCollectionCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/15.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZFindCollectionCell.h"

@interface QZFindCollectionCell ()


//@property (nonatomic,strong)UIImageView *bgVagueImgView;


@property (nonatomic,strong)UILabel * titleLab;

@property (nonatomic,strong)UIButton *releaseTimeBtn;

@property (nonatomic,strong)UIButton *commentBtn;

@property (nonatomic,strong)UIButton *quanziBtn;

@end

@implementation QZFindCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.bgImgView];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.releaseTimeBtn];
        [self.contentView addSubview:self.quanziBtn];
    }
    return self;
}
#pragma mark -- Event Response
- (void)quanZiActionClicked:(UIButton *)button {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(qzFindCollectionCell:didClieckedQZActionWithHashName:)]) {
            [_delegate qzFindCollectionCell:self didClieckedQZActionWithHashName:self.feedModel.circle_hash];
        }
    }
}
#pragma mark -- private method
- (UIButton *)createNormalButtonWithImageName:(NSString *)imageName {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithHexstring:@"b5b5b5"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.backgroundColor = [UIColor clearColor];
    return button;
}
- (void)layoutButtonContentView:(UIButton *)sender isHaveImage:(BOOL)isHaveImage {
    sender.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    sender.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
}
#pragma mark -- setter && getter

- (void)setFeedModel:(FeedModel *)feedModel {
    _feedModel = feedModel;
    _titleLab.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, feedModel.titleHeight);
    if (feedModel.isHaveImageURL) {
        _bgImgView.frame = CGRectMake(_titleLab.left, _titleLab.bottom + 10, SCREEN_WIDTH-20, feedModel.imageHeight);
        _commentBtn.frame = CGRectMake(SCREEN_WIDTH - 80, _bgImgView.bottom +10, 70, 20);
        _releaseTimeBtn.frame = CGRectMake(_commentBtn.left - 100, _bgImgView.bottom + 10, 100, 20);
        _quanziBtn.frame = CGRectMake(_titleLab.left, _bgImgView.bottom+10, SCREEN_WIDTH - _releaseTimeBtn.left-10, 20);
    } else  {
        _bgImgView.frame = CGRectMake(_titleLab.left, _titleLab.bottom +10, SCREEN_WIDTH-20, 0);
        _commentBtn.frame = CGRectMake(SCREEN_WIDTH - 80, _bgImgView.bottom, 70, 20);
        _releaseTimeBtn.frame = CGRectMake(_commentBtn.left - 100, _bgImgView.bottom , 100, 20);
        _quanziBtn.frame = CGRectMake(_titleLab.left, _bgImgView.bottom, SCREEN_WIDTH - _releaseTimeBtn.left-10, 20);
    }
    CGRect quanziFrame = _quanziBtn.frame;
    CGRect frame = [_releaseTimeBtn convertRect:_releaseTimeBtn.imageView.frame toView:self.contentView];
    quanziFrame.size.width =  frame.origin.x -10;
    _quanziBtn.frame = quanziFrame;
    
    self.titleLab.text = feedModel.title;
    [self.quanziBtn setTitle:feedModel.circle_name forState:UIControlStateNormal];
    [self.releaseTimeBtn setTitle:feedModel.live_time forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%d票",[feedModel.all_vote intValue]] forState:UIControlStateNormal];
    [self layoutButtonContentView:_quanziBtn isHaveImage:feedModel.isHaveImageURL];
    [self layoutButtonContentView:_releaseTimeBtn isHaveImage:feedModel.isHaveImageURL];
    [self layoutButtonContentView:_commentBtn isHaveImage:feedModel.isHaveImageURL];
}

#pragma mark -- getter
- (UILabel *)titleLab {    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHexstring:@"333333"];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
        _titleLab.numberOfLines = 2;
        _titleLab.backgroundColor = [UIColor clearColor];
    }
    return _titleLab;
}
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
    }
    return _bgImgView;
}
- (UIButton *)quanziBtn {
    if (!_quanziBtn) {
        _quanziBtn = [self createNormalButtonWithImageName:@"icon_quanzi.png"];
        [_quanziBtn setTitleColor:[UIColor colorWithHexstring:@"507daf"] forState:UIControlStateNormal];
        _quanziBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _quanziBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_quanziBtn addTarget:self action:@selector(quanZiActionClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quanziBtn;
}
- (UIButton *)releaseTimeBtn {
    if (!_releaseTimeBtn) {
        _releaseTimeBtn = [self createNormalButtonWithImageName:@"icon_time.png"];
        _releaseTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _releaseTimeBtn;
}
- (UIButton *)commentBtn {
    
    if (!_commentBtn) {
        _commentBtn = [self createNormalButtonWithImageName:@"icon_homepage_toupiao.png"];
        _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    }
    return _commentBtn;
}

@end
