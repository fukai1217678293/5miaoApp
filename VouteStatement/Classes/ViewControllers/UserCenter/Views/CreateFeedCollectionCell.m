//
//  CreateFeedCollectionCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CreateFeedCollectionCell.h"

@interface CreateFeedCollectionCell ()

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *leftOptionLabel;

@property (nonatomic,strong)UILabel *rightOptionLabel;

@property (nonatomic,strong)UIImageView *vsImageView;

@property (nonatomic,strong)UIImageView *arrowImageView;

@property (nonatomic,strong)UILabel *voteTitle;

@property (nonatomic,strong)UIButton *hiddenDateButton;

@end

@implementation CreateFeedCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.leftOptionLabel];
        [self.contentView addSubview:self.vsImageView];
        [self.contentView addSubview:self.rightOptionLabel];
        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.voteTitle];
        [self.contentView addSubview:self.hiddenDateButton];
        
        WEAKSELF;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
        }];
        
        [_hiddenDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
            make.width.equalTo(@95);
            make.height.equalTo(@15);
        }];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.centerY.equalTo(weakSelf.hiddenDateButton.mas_centerY);
            make.height.equalTo(@22);
            make.width.equalTo(@13.5);
        }];
        [_voteTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.arrowImageView.mas_right);
//            make.right.equalTo(weakSelf.hiddenDateButton.mas_left);
            make.centerY.equalTo(weakSelf.hiddenDateButton.mas_centerY);
            make.height.equalTo(@22);
        }];
        
        [_leftOptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
            make.bottom.equalTo(weakSelf.voteTitle.mas_top).offset(-10);
            make.height.equalTo(@15);
        }];
        [_vsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftOptionLabel.mas_right).offset(3);
            make.centerY.equalTo(weakSelf.leftOptionLabel.mas_centerY);
            make.width.height.equalTo(@16);
        }];
        [_rightOptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.vsImageView.mas_right).offset(3);
            make.centerY.equalTo(weakSelf.leftOptionLabel.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        }];
    }
    return self;
}
- (void)setDataModel:(MyCreateListModel *)dataModel {
    _dataModel = dataModel;
    _titleLabel.text = dataModel.title;
    _leftOptionLabel.text = [NSString stringWithFormat:@"%@(%@)",dataModel.left_option,dataModel.left_vote];
    _rightOptionLabel.text = [NSString stringWithFormat:@"%@(%@)",dataModel.right_option,dataModel.right_vote];
    if (dataModel.voted) {
        _voteTitle.hidden = NO;
        _arrowImageView.hidden = NO;
        NSString *title;
        if ([dataModel.side isEqualToString:@"left"]) {
            title = [NSString stringWithFormat:@"为%@投了%d票  ",dataModel.left_option,[dataModel.self_vote intValue]];
        } else {
            title = [NSString stringWithFormat:@"为%@投了%d票  ",dataModel.right_option,[dataModel.self_vote intValue]];
        }
        _voteTitle.text = title;
    } else {
        _voteTitle.hidden = YES;
        _arrowImageView.hidden = YES;
    }
    _hiddenDateButton.hidden = [NSString isBlankString:dataModel.live_time];
    [_hiddenDateButton setTitle:dataModel.live_time forState:UIControlStateNormal];
    [_hiddenDateButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
}
#pragma mark --getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:19];
        _titleLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UILabel *)leftOptionLabel {
    if (!_leftOptionLabel) {
        _leftOptionLabel = [[UILabel alloc] init];
        _leftOptionLabel.backgroundColor = [UIColor clearColor];
        _leftOptionLabel.textAlignment = NSTextAlignmentLeft;
        _leftOptionLabel.font = [UIFont systemFontOfSize:14];
        _leftOptionLabel.textColor = [UIColor colorWithHexstring:@"999999"];
        [_leftOptionLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _leftOptionLabel;
}
- (UIImageView *)vsImageView {
    if (!_vsImageView) {
        _vsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_vsquan.png"]];
        _vsImageView.backgroundColor = [UIColor clearColor];
    }
    return _vsImageView;
}
- (UILabel *)rightOptionLabel {
    if (!_rightOptionLabel) {
        _rightOptionLabel = [[UILabel alloc] init];
        _rightOptionLabel.backgroundColor = [UIColor clearColor];
        _rightOptionLabel.textAlignment = NSTextAlignmentLeft;
        _rightOptionLabel.font = [UIFont systemFontOfSize:14];
        _rightOptionLabel.textColor = [UIColor colorWithHexstring:@"999999"];
    }
    return _rightOptionLabel;
}
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_toupiao-.png"]];
        _arrowImageView.backgroundColor = [UIColor clearColor];
    }
    return _arrowImageView;
}
- (UILabel *)voteTitle {
    if (!_voteTitle) {
        _voteTitle =[[UILabel alloc] init];
        _voteTitle.backgroundColor = [UIColor colorWithHexstring:@"f3f3f3"];
        _voteTitle.textAlignment = NSTextAlignmentLeft;
        _voteTitle.font = [UIFont systemFontOfSize:14];
        _voteTitle.textColor = [UIColor colorWithHexstring:@"b2b2b2"];
    }
    return _voteTitle;
}
- (UIButton *)hiddenDateButton {
    if (!_hiddenDateButton) {
        _hiddenDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hiddenDateButton setImage:[UIImage imageNamed:@"icon_time.png"] forState:UIControlStateNormal];
        [_hiddenDateButton setTitleColor:[UIColor colorWithHexstring:@"b2b2b2"] forState:UIControlStateNormal];
        _hiddenDateButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _hiddenDateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _hiddenDateButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _hiddenDateButton;
}
@end
