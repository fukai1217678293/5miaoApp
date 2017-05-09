//
//  VouteHeaderView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VouteHeaderView.h"
#import "VoteSliderView.h"

NSString * const VouteHeaderViewFilterDidClickedNotificationName = @"VouteHeaderViewFilterDidClickedNotificationName";


@interface VouteHeaderView ()

@property (nonatomic,strong)UIImageView *vsImageView;
@property (nonatomic,strong)UILabel *leftNoVotedView;
@property (nonatomic,strong)UILabel *rightNoVotedView;

@property (nonatomic,strong)UIView *leftDidVotedView;
@property (nonatomic,strong)UIView *rightDidVotedView;

@end

@implementation VouteHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.vsImageView];
    }
    return self;
}


- (void)configSubViewsWithDataModel:(FeedDetailModel *)dataModel {
    if (dataModel.voted) {
        if (self.leftNoVotedView.superview) {
            [self.leftNoVotedView removeFromSuperview];
        }
        if (self.rightNoVotedView.superview) {
            [self.rightNoVotedView removeFromSuperview];
        }
        if (!self.leftDidVotedView.superview) {
            [self addSubview:self.leftDidVotedView];
        }
        if (!self.rightDidVotedView.superview) {
            [self addSubview:self.rightDidVotedView];
        }
        //标题
        UILabel *leftOptionLabel = [_leftDidVotedView viewWithTag:100];
        //投票数
        UILabel *leftCountLabel = [_leftDidVotedView viewWithTag:101];
        
        //投票数
        NSString *leftCountString = [NSString stringWithFormat:@"%@票",dataModel.left_vote];
        CGFloat leftCountWidth = [self getRealWidthByVoteString:leftCountString];
        leftCountLabel.frame = CGRectMake((_vsImageView.left-leftCountWidth)/2.0f, 7.5f, leftCountWidth, 20);
        leftCountLabel.text = leftCountString;
    
        //选项
        leftOptionLabel.text = dataModel.left_option;
        
        UILabel *rightOptionLabel = [_rightDidVotedView viewWithTag:102];
        UILabel *rightCountLabel = [_rightDidVotedView viewWithTag:103];
        
        NSString *rightCountString = [NSString stringWithFormat:@"%@票",dataModel.right_vote];
        CGFloat rightCountWidth = [self getRealWidthByVoteString:rightCountString];
        rightCountLabel.frame = CGRectMake((_rightDidVotedView.width-rightCountWidth)/2.0f, (70/2.0f - 20)/2.0f, rightCountWidth, 20);
        rightCountLabel.text = rightCountString;
        rightOptionLabel.text = dataModel.right_option;
        [self bringSubviewToFront:self.vsImageView];
        if ([dataModel.side isEqualToString:@"left"]) {
            leftCountLabel.backgroundColor = [UIColor colorWithHexstring:@"fd3768"];
            leftCountLabel.textColor = [UIColor whiteColor];
            rightCountLabel.backgroundColor = [UIColor colorWithHexstring:@"cccccc"];
            rightCountLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        }else {
            leftCountLabel.backgroundColor = [UIColor colorWithHexstring:@"cccccc"];
            leftCountLabel.textColor = [UIColor colorWithHexstring:@"333333"];
            rightCountLabel.backgroundColor = [UIColor colorWithHexstring:@"fd3768"];
            rightCountLabel.textColor = [UIColor whiteColor];
        }

    } else {
        if (self.leftDidVotedView.superview) {
            [self.leftDidVotedView removeFromSuperview];
        }
        if (self.rightDidVotedView.superview) {
            [self.rightDidVotedView removeFromSuperview];
        }
        [self addSubview:self.leftNoVotedView];
        [self addSubview:self.rightNoVotedView];
        _leftNoVotedView.text = dataModel.left_option;
        _rightNoVotedView.text = dataModel.right_option;
       
    }
}
- (CGFloat)getRealWidthByVoteString:(NSString *)voteString {
    CGFloat width = [voteString boundingRectWithSize:CGSizeMake(MAXFLOAT,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} context:nil].size.width;
    width = width > _vsImageView.left ? _vsImageView.left : width;
    //小于25的情况下 近乎圆形的形状
    width = width >=35 ? width : 35;
    return width;
}
#pragma mark -- setter

#pragma mark -- getter
- (UIImageView *)vsImageView {
    if (!_vsImageView) {
        _vsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_vsbig.png"]];
        _vsImageView.backgroundColor = [UIColor clearColor];
        _vsImageView.frame = CGRectMake((SCREEN_WIDTH-40)/2.0f, 15, 40, 40);
    }
    return _vsImageView;
}
- (UILabel *)leftNoVotedView {
    if (!_leftNoVotedView) {
        _leftNoVotedView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _vsImageView.left, 70)];
        _leftNoVotedView.textColor = [UIColor colorWithHexstring:@"333333"];
        _leftNoVotedView.textAlignment = NSTextAlignmentCenter;
        _leftNoVotedView.backgroundColor = [UIColor clearColor];
        _leftNoVotedView.font = [UIFont systemFontOfSize:19];
    }
    return _leftNoVotedView;
}
- (UILabel *)rightNoVotedView {
    if (!_rightNoVotedView) {
        _rightNoVotedView = [[UILabel alloc] initWithFrame:CGRectMake(_vsImageView.right, 0, _vsImageView.left, 70)];
        _rightNoVotedView.textColor = [UIColor colorWithHexstring:@"333333"];
        _rightNoVotedView.textAlignment = NSTextAlignmentCenter;
        _rightNoVotedView.backgroundColor = [UIColor clearColor];
        _rightNoVotedView.font = [UIFont systemFontOfSize:19];
    }
    return _rightNoVotedView;
}
- (UIView *)leftDidVotedView {
    if (!_leftDidVotedView) {
        _leftDidVotedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vsImageView.left, 70)];
        _leftDidVotedView.backgroundColor = [UIColor clearColor];
        
        UILabel *optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, _vsImageView.left, 35)];
        optionLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        optionLabel.textAlignment = NSTextAlignmentCenter;
        optionLabel.backgroundColor = [UIColor clearColor];
        optionLabel.font = [UIFont systemFontOfSize:16];
        optionLabel.tag = 100;
        optionLabel.backgroundColor = [UIColor clearColor];
        [_leftDidVotedView addSubview:optionLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake( _vsImageView.left/2.0f, ((70/2.0f)-20)/2.0f, 0, 20)];
        countLabel.backgroundColor = [UIColor colorWithHexstring:@"f3f3f3"];
        countLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        countLabel.layer.cornerRadius = 10.0f;
        countLabel.layer.masksToBounds = YES;
        countLabel.font = [UIFont systemFontOfSize:10.0f];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.tag = 101;
        [_leftDidVotedView addSubview:countLabel];
    }
    return _leftDidVotedView;
}
- (UIView *)rightDidVotedView {
    if (!_rightDidVotedView) {
        _rightDidVotedView = [[UIView alloc] initWithFrame:CGRectMake(_vsImageView.right, 0, SCREEN_WIDTH - _vsImageView.right, 70)];
        _rightDidVotedView.backgroundColor = [UIColor clearColor];
        
        UILabel *optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70/2.0f, _rightDidVotedView.width, 70/2.0f)];
        optionLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        optionLabel.backgroundColor = [UIColor clearColor];
        optionLabel.textAlignment = NSTextAlignmentCenter;
        optionLabel.font = [UIFont systemFontOfSize:16];
        optionLabel.tag = 102;
        [_rightDidVotedView addSubview:optionLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 0, 0)];
        countLabel.backgroundColor = [UIColor colorWithHexstring:@"fd3768"];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.layer.cornerRadius = 10.0f;
        countLabel.layer.masksToBounds = YES;
        countLabel.font = [UIFont systemFontOfSize:10.0f];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.tag = 103;
        [_rightDidVotedView addSubview:countLabel];
    }
    return _rightDidVotedView;
}
@end
