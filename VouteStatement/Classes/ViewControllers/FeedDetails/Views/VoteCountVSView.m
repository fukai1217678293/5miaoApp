//
//  VoteCountVSView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VoteCountVSView.h"
#import "VSMaskLabel.h"
@interface VoteCountVSView ()

//投票前
@property (nonatomic,strong)UIControl   *voteEventControl;
@property (nonatomic,strong)UILabel     *totalVoteCountLabel;
//@property (nonatomic,strong)UILabel     *tipLabel;
//@property (nonatomic,strong)UIButton    *toVoteButton;
@property (nonatomic,strong)UILabel     *voteTitleLabel;
//投票后

@property (nonatomic,strong)UIButton    *agreeVoteCountButton;
@property (nonatomic,strong)UIButton    *disagreeVoteCountButton;


//@property (nonatomic,strong)UILabel     *agreePointsLabel;
//@property (nonatomic,strong)UILabel     *disagreePointsLabel;
@property (nonatomic,strong)VSMaskLabel *vsLabel;

@property (nonatomic,assign)BOOL isVoted;

@end

@implementation VoteCountVSView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth      = 0.7f;
        self.layer.borderColor      = UIRGBColor(220, 220, 220, 1.0f).CGColor;
        self.layer.cornerRadius     = frame.size.height/2.0f;
        self.layer.masksToBounds    = YES;
    }
    return self;
}

- (void)configSubViewBeforeVote {
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    self.backgroundColor = UIRGBColor(247, 26, 85, 1.0f);
    [self addSubview:self.voteTitleLabel];
    [self addSubview:self.totalVoteCountLabel];
    [self addSubview:self.voteEventControl];
}
- (void)configSubViewAfterVote {
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.vsLabel];
    [self addSubview:self.agreeVoteCountButton];
    [self addSubview:self.disagreeVoteCountButton];
}
#pragma mark -- action method
- (void)voteActionClicked:(UIControl *)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(voteCountVSView:didClickedToVote:)]) {
            [_delegate voteCountVSView:self didClickedToVote:sender];
        }
    }
}
#pragma mark -- setter
- (void)setFeedDetailModel:(FeedDetailModel *)feedDetailModel {
    _feedDetailModel =feedDetailModel;
//    self.isVoted = [feedDetailModel.voted intValue];
    
}
- (void)setIsVoted:(BOOL)isVoted {
    _isVoted = isVoted;
    if (isVoted) {
        [self configSubViewAfterVote];
//        BOOL side = [self.feedDetailModel.side intValue];
//        NSString * posVote = [NSString stringWithFormat:@"%@",self.feedDetailModel.pos_vote];
//        NSString *agreeLabelText = [NSString stringWithFormat:@"%@票",posVote];
//        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:agreeLabelText];
//        NSString *disagreeLabelText = [NSString stringWithFormat:@"%d票",[self.feedDetailModel.neg_vote intValue]];
//        NSMutableAttributedString * attr1 = [[NSMutableAttributedString alloc] initWithString:disagreeLabelText];
//        
//        if (side) {//pos
//            [attr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIRGBColor(38, 38, 38, 1.0f),NSForegroundColorAttributeName,[UIFont systemFontOfSize:23],NSFontAttributeName, nil] range:NSMakeRange(0, posVote.length)];
//            [attr1 setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIRGBColor(83, 83, 83, 1.0f),NSForegroundColorAttributeName,[UIFont systemFontOfSize:23],NSFontAttributeName, nil] range:NSMakeRange(0, [NSString stringWithFormat:@"%@",self.feedDetailModel.neg_vote].length)];
//            _agreeVoteCountButton.backgroundColor = UIRGBColor(218, 218, 218, 1);
//            _disagreeVoteCountButton.backgroundColor =[UIColor whiteColor];
//
//        }
//        else {
//            [attr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIRGBColor(83, 83, 83, 1.0f),NSForegroundColorAttributeName,[UIFont systemFontOfSize:23],NSFontAttributeName, nil] range:NSMakeRange(0, posVote.length)];
//            [attr1 setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIRGBColor(38, 38, 38, 1.0f),NSForegroundColorAttributeName,[UIFont systemFontOfSize:23],NSFontAttributeName, nil] range:NSMakeRange(0, [NSString stringWithFormat:@"%@",self.feedDetailModel.neg_vote].length)];
//            _agreeVoteCountButton.backgroundColor = [UIColor whiteColor];
//            _disagreeVoteCountButton.backgroundColor = UIRGBColor(218, 218, 218, 1);
//        }
//        _agreeVoteCountButton.selected = side;
//        _disagreeVoteCountButton.selected = !side;
//        [_agreeVoteCountButton setTitle:agreeLabelText forState:UIControlStateNormal];
//        [_agreeVoteCountButton setAttributedTitle:attr forState:UIControlStateNormal];
//        [_disagreeVoteCountButton setTitle:disagreeLabelText forState:UIControlStateNormal];
//        [_disagreeVoteCountButton setAttributedTitle:attr1 forState:UIControlStateNormal];
//        self.vsLabel.triangleTopLeft =  side;
    }
    else {
        [self configSubViewBeforeVote];
        NSString * totalCount = [NSString stringWithFormat:@"已有%d票,投票后见结果",[self.feedDetailModel.all_vote intValue]];
        self.totalVoteCountLabel.text = totalCount;
    }
}
#pragma mark --getter
//before vote
- (UILabel *)voteTitleLabel {
    if (!_voteTitleLabel) {
        _voteTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height/2.0f)];
        _voteTitleLabel.backgroundColor = [UIColor clearColor];
        _voteTitleLabel.textAlignment = NSTextAlignmentCenter;
        _voteTitleLabel.font = [UIFont systemFontOfSize:17];
        _voteTitleLabel.textColor = [UIColor whiteColor];
        _voteTitleLabel.text = @"投票";
    }
    return _voteTitleLabel;
}
- (UILabel *)totalVoteCountLabel {
    if (!_totalVoteCountLabel) {
        _totalVoteCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2.0f, self.width, self.height/2.0f)];
        _totalVoteCountLabel.backgroundColor = [UIColor clearColor];
        _totalVoteCountLabel.textAlignment = NSTextAlignmentCenter;
        _totalVoteCountLabel.font = [UIFont systemFontOfSize:11];
        _totalVoteCountLabel.textColor = [UIColor whiteColor];
    }
    return _totalVoteCountLabel;
}
- (UIControl *)voteEventControl {
    if (!_voteEventControl) {
        _voteEventControl = [[UIControl alloc] initWithFrame:self.bounds];
        _voteEventControl.backgroundColor = [UIColor clearColor];
        [_voteEventControl addTarget:self action:@selector(voteActionClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voteEventControl;
}
//after vote
- (UILabel *)vsLabel {
    if (!_vsLabel) {
        _vsLabel = [[VSMaskLabel alloc] initWithFrame:CGRectMake(self.width/2.0f-20, 0, 40, self.height)];
        _vsLabel.backgroundColor = [UIColor clearColor];
        _vsLabel.text = @"VS";
        _vsLabel.font = [UIFont systemFontOfSize:22];
        _vsLabel.textColor = UIRGBColor(63, 63, 63, 1.0f);
        _vsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _vsLabel;
}
- (UIButton *)agreeVoteCountButton {
    if (!_agreeVoteCountButton) {
        _agreeVoteCountButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeVoteCountButton.frame = CGRectMake(0, 0, _vsLabel.left, self.height);
        _agreeVoteCountButton.backgroundColor = UIRGBColor(218, 218, 218, 1);
        [_agreeVoteCountButton setImage:[UIImage imageNamed:@"icon_bigyeswx.png"] forState:UIControlStateNormal];
        [_agreeVoteCountButton setImage:[UIImage imageNamed:@"icon_bigyes.png"] forState:UIControlStateSelected];
        [_agreeVoteCountButton setTitleColor:UIRGBColor(83, 83, 83, 1) forState:UIControlStateNormal];
        [_agreeVoteCountButton setTitleColor:UIRGBColor(38, 38, 38, 1) forState:UIControlStateSelected];
        _agreeVoteCountButton.titleLabel.font = [UIFont systemFontOfSize:11];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_agreeVoteCountButton.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(_agreeVoteCountButton.height/2.0f, _agreeVoteCountButton.height/2.0f)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame         = _agreeVoteCountButton.bounds;
        maskLayer.path          = maskPath.CGPath;
        _agreeVoteCountButton.layer.mask = maskLayer;
        
    }
    return _agreeVoteCountButton;
}
- (UIButton *)disagreeVoteCountButton {
    if (!_disagreeVoteCountButton) {
        _disagreeVoteCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _disagreeVoteCountButton.frame = CGRectMake(_vsLabel.right, 0,self.width- _vsLabel.right, self.height);
        _disagreeVoteCountButton.backgroundColor = UIRGBColor(218, 218, 218, 1);
        [_disagreeVoteCountButton setImage:[UIImage imageNamed:@"icon_bignowx.png"] forState:UIControlStateNormal];
        [_disagreeVoteCountButton setImage:[UIImage imageNamed:@"icon_bigno.png"] forState:UIControlStateSelected];
        [_disagreeVoteCountButton setTitleColor:UIRGBColor(83, 83, 83, 1) forState:UIControlStateNormal];
        [_disagreeVoteCountButton setTitleColor:UIRGBColor(38, 38, 38, 1) forState:UIControlStateSelected];
        _disagreeVoteCountButton.titleLabel.font = [UIFont systemFontOfSize:11];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_disagreeVoteCountButton.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(_disagreeVoteCountButton.height/2.0f, _disagreeVoteCountButton.height/2.0f)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _disagreeVoteCountButton.bounds;
        maskLayer.path = maskPath.CGPath;
        _disagreeVoteCountButton.layer.mask = maskLayer;
    }
    return _disagreeVoteCountButton;
}

@end
