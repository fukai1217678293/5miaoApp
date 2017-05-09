//
//  FeedsListCollectionCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedsListCollectionCell.h"
#import <UIImageView+WebCache.h>

NSString * const FeedListCollectionCellDataDictionaryPicKey = @"FeedListCollectionCellDataDictionaryPicKey";
NSString * const FeedListCollectionCellDataDictionaryTitleKey = @"FeedListCollectionCellDataDictionaryTitleKey";
NSString * const FeedListCollectionCellDataDictionaryLeftTitleKey = @"FeedListCollectionCellDataDictionaryLeftTitleKey";
NSString * const FeedListCollectionCellDataDictionaryRightTitleKey = @"FeedListCollectionCellDataDictionaryRightTitleKey";

@interface FeedsListCollectionCell ()

@property (nonatomic,strong)UILabel     *titleLab;
@property (nonatomic,strong)UIImageView *feedPic;
@property (nonatomic,strong)UIButton    *leftButton;
@property (nonatomic,strong)UIButton    *centerButton;
@property (nonatomic,strong)UIButton    *rightButton;

@end

@implementation FeedsListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.feedPic];
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.rightButton];
        [self.contentView addSubview:self.centerButton];
//        [self configLayout]
    }
    return self;
}
#pragma mark -- setter
- (void)configLayout {
    
    WEAKSELF;
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-150);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
    }];
    [_feedPic mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.titleLab.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.top.equalTo(weakSelf.titleLab.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_height).offset(15);
    }];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.titleLab.mas_left);
        make.width.equalTo(@90);
        make.bottom.equalTo(weakSelf.feedPic.mas_bottom);
    }];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(weakSelf.titleLab.mas_right);
        make.top.equalTo(weakSelf.leftButton.mas_top);
        make.width.equalTo(weakSelf.leftButton.mas_width);
    }];
}
- (void)setFeed:(FeedExtentionModel *)feed {
    _feed = feed;
    self.titleLab.text = feed.title;
    [self.feedPic sd_setImageWithURL:[NSURL URLWithString:feed.pic] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    if ([feed.voted intValue]) {//是否投票过
        _centerButton.hidden = NO;
        [_rightButton setImage:[UIImage imageNamed:@"icon_smallno.png"] forState:UIControlStateNormal];
        if ([feed.side isEqualToString:@"pos"]) {
            _centerButton.selected = YES;
            _rightButton.selected = NO;
        }
        else {
            _centerButton.selected = NO;
            _rightButton.selected = YES;
        }
        [_centerButton setTitle:[NSString stringWithFormat:@"%d",[feed.pos_vote intValue]] forState:UIControlStateNormal];
        [_rightButton setTitle:[NSString stringWithFormat:@"%d",[feed.neg_vote intValue]] forState:UIControlStateNormal];
    }
    else {
        _centerButton.selected = NO;
        _rightButton.selected = NO;
        _centerButton.hidden = YES;
        [_rightButton setImage:[UIImage imageNamed:@"icon_homepage_toupiao.png"] forState:UIControlStateNormal];
        [_rightButton setTitle:[NSString stringWithFormat:@"%d票",[feed.all_vote intValue]] forState:UIControlStateNormal];
    }
//    [_leftButton setTitle:feed.add_date forState:UIControlStateNormal];
   
    _leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    _rightButton.imageEdgeInsets= UIEdgeInsetsMake(0, -4, 0, 4);
    _centerButton.titleEdgeInsets= UIEdgeInsetsMake(0, 2, 0, -2);
    _centerButton.imageEdgeInsets= UIEdgeInsetsMake(0, -2, 0, 2);
}

- (void)setDataDict:(NSDictionary *)dataDict {
    
    _dataDict = dataDict;
    
    NSString *picURLString = dataDict[FeedListCollectionCellDataDictionaryPicKey];
    NSString *title        = dataDict[FeedListCollectionCellDataDictionaryTitleKey];
    NSString *leftTitle    = dataDict[FeedListCollectionCellDataDictionaryLeftTitleKey];
    NSString *rightTitle   = dataDict[FeedListCollectionCellDataDictionaryRightTitleKey];
    _titleLab.text = title;
    [_feedPic sd_setImageWithURL:[NSURL URLWithString:picURLString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [_leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
    _leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
    _rightButton.imageEdgeInsets= UIEdgeInsetsMake(0, -8, 0, 8);
    _centerButton.titleEdgeInsets= UIEdgeInsetsMake(0, 4, 0, -4);
    _centerButton.imageEdgeInsets= UIEdgeInsetsMake(0, -4, 0, 4);

}
#pragma mark -- getter
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, SCREEN_WIDTH-150, 35)];
        _titleLab.numberOfLines = 2;
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.contentMode = UIViewContentModeTopLeft;
        _titleLab.textColor = [UIColor blackColor];
    }
    return _titleLab;
}
- (UIImageView *)feedPic {
    
    if (!_feedPic) {
        _feedPic = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLab.right+10, _titleLab.top, 120, 60)];
        _feedPic.backgroundColor = [UIColor clearColor];
        _feedPic.contentMode = UIViewContentModeScaleAspectFit;
        _feedPic.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _feedPic;
}
- (UIButton *)leftButton {
    
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.backgroundColor = [UIColor clearColor];
        _leftButton.frame = CGRectMake(_titleLab.left, _feedPic.bottom-20, 70, 20);
        [_leftButton setTitleColor:UIRGBColor(151, 151, 151, 1.0f) forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftButton setImage:[UIImage imageNamed:@"icon_time.png"] forState:UIControlStateNormal];
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.backgroundColor = [UIColor clearColor];
        _rightButton.frame = CGRectMake(_feedPic.left-80, _leftButton.top, 70, 20);
        [_rightButton setTitleColor:UIRGBColor(151, 151, 151, 1.0f) forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIRGBColor(249, 0, 73, 1.0f) forState:UIControlStateSelected];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

        _rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rightButton setImage:[UIImage imageNamed:@"icon_smallno.png"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"icon_smallnoxz.png"] forState:UIControlStateSelected];
    }
    return _rightButton;
}
- (UIButton *)centerButton {
    
    if (!_centerButton) {
        _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerButton.backgroundColor = [UIColor clearColor];
        _centerButton.frame = CGRectMake(_leftButton.right, _leftButton.top, _rightButton.left-_leftButton.right, 20);
        [_centerButton setTitleColor:UIRGBColor(151, 151, 151, 1.0f) forState:UIControlStateNormal];
        [_centerButton setTitleColor:UIRGBColor(249, 0, 73, 1.0f) forState:UIControlStateSelected];
        _centerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _centerButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_centerButton setImage:[UIImage imageNamed:@"icon_smallyes.png"] forState:UIControlStateNormal];
        [_centerButton setImage:[UIImage imageNamed:@"icon_smallyesxz.png"] forState:UIControlStateSelected];

    }
    return _centerButton;
    
}
@end
