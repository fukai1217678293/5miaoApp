//
//  LocalFindCollectionCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LocalFindCollectionCell.h"

@interface LocalFindCollectionCell ()

@property (nonatomic,strong)UILabel * titleLab;

@property (nonatomic,strong)UIButton *releaseTimeBtn;

@property (nonatomic,strong)UIButton *commentBtn;


@end

@implementation LocalFindCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
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
    
    return button;
}
- (void)layoutButtonContentView:(UIButton *)sender isHaveImage:(BOOL)isHaveImage {
    sender.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    sender.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
}
#pragma mark -- setter && getter

- (void)setFeedModel:(LocalFindModel *)feedModel {
    _feedModel = feedModel;
    _titleLab.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, feedModel.titleHeight);
    if (feedModel.isHaveImageURL) {
        _bgImgView.hidden = NO;
        _bgImgView.frame = CGRectMake(_titleLab.left, _titleLab.bottom + 10, SCREEN_WIDTH-20, feedModel.imageHeight);
        _commentBtn.frame = CGRectMake(SCREEN_WIDTH - 80, _bgImgView.bottom +10, 70, 20);
        _releaseTimeBtn.frame = CGRectMake(_commentBtn.left - 150, _bgImgView.bottom + 10, 100, 20);
    } else  {
        _bgImgView.hidden = YES;
        _bgImgView.frame = CGRectMake(_titleLab.left, _titleLab.bottom +10, SCREEN_WIDTH-20, 0);
        _commentBtn.frame = CGRectMake(SCREEN_WIDTH - 80, _bgImgView.bottom, 70, 20);
        _releaseTimeBtn.frame = CGRectMake(_commentBtn.left - 150, _bgImgView.bottom , 100, 20);
    }
    
    self.titleLab.text = feedModel.title;
    _releaseTimeBtn.hidden = !feedModel.isNearby;
    [_commentBtn setTitle:[NSString stringWithFormat:@"%d票",[feedModel.all_vote intValue]] forState:UIControlStateNormal];
    [_releaseTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    [_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
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
        _releaseTimeBtn = [self createNormalButtonWithImageName:@"icon_weizhi.png"];
        [_releaseTimeBtn setTitle:@"附近" forState:UIControlStateNormal];
        _releaseTimeBtn.hidden = YES;
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
