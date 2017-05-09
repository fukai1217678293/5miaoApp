//
//  QZHomeListCollectionCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZHomeListCollectionCell.h"
#import "QZHomeHeaderView.h"

@interface QZHomeListCollectionCell ()


@property (nonatomic,strong)UILabel * titleLab;

@property (nonatomic,strong)UIButton *releaseTimeBtn;

@property (nonatomic,strong)UIButton *commentBtn;


@end

@implementation QZHomeListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.bgImgView];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.releaseTimeBtn];
    }
    return self;
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
    } else  {
        _bgImgView.frame = CGRectMake(_titleLab.left, _titleLab.bottom +10, SCREEN_WIDTH-20, 0);
        _commentBtn.frame = CGRectMake(SCREEN_WIDTH - 80, _bgImgView.bottom, 70, 20);
        _releaseTimeBtn.frame = CGRectMake(_commentBtn.left - 100, _bgImgView.bottom , 100, 20);
    }
    self.titleLab.text = feedModel.title;
    [self.releaseTimeBtn setTitle:feedModel.live_time forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%d票",[feedModel.all_vote intValue]] forState:UIControlStateNormal];
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

- (UIButton *)releaseTimeBtn {
    if (!_releaseTimeBtn) {
        _releaseTimeBtn = [self createNormalButtonWithImageName:@"icon_time.png"];
        _releaseTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
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

@interface QZInformationCollectionCell ()<QZHomeHeaderViewDelegate>

@property (nonatomic,strong)QZHomeHeaderView *qzHeaderView;
@end

@implementation QZInformationCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.qzHeaderView];
    }
    return self;
}
- (void)qzHomeHeaderView:(QZHomeHeaderView *)headerView didClickedJoinButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(qzInformationCollectionCell:didClickedJoinQZButton:)]) {
        [_delegate qzInformationCollectionCell:self didClickedJoinQZButton:button];
    }
}
#pragma mark -- setter
- (void)setInformationModel:(QZInformationModel *)informationModel {
    _informationModel = informationModel;
    [_qzHeaderView updateInformationWithDataSource:informationModel];
}
#pragma mark -- getter
- (QZHomeHeaderView *)qzHeaderView{
    if (!_qzHeaderView) {
        _qzHeaderView = [[QZHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _qzHeaderView.delegate = self;
    }
    return _qzHeaderView;
}
@end

