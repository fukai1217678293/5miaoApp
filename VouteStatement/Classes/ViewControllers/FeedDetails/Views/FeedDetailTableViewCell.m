//
//  FeedDetailTableViewCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedDetailTableViewCell.h"
#import "VoteContentView.h"
#import "VouteHeaderView.h"
#import <Masonry.h>
NSString * const FeedDetailTableViewTitleCellIdentifier = @"FeedDetailTableViewTitleCellIdentifier";
NSString * const  FeedDetailTableViewFeedContentCellIdentifier = @"FeedDetailTableViewFeedContentCellIdentifier";
NSString * const FeedDetailTableViewPointVSCellIdentifier = @"FeedDetailTableViewPointVSCellIdentifier";
NSString * const FeedDetailTableViewCommentHeaderCellIdentifier = @"FeedDetailTableViewCommentHeaderCellIdentifier";
NSString * const FeedDetailTableViewCommentCellIdentifier = @"FeedDetailTableViewCommentCellIdentifier";


@interface FeedDetailTableViewCell ()<VoteCountVSViewDelegate,CommentViewDelegate>

//FeedDetailTableViewTitleCellIdentifier

@property (nonatomic,strong)UIView      *titleView;

//FeedDetailTableViewVoteCountCellIdentifier
//@property (nonatomic,strong)VoteCountVSView *voteCountView;

//FeedDetailTableViewFeedContentCellIdentifier
@property (nonatomic,strong)UILabel     *contentLabel;

//FeedDetailTableViewPointVSCellIdentifier
@property (nonatomic,strong)VouteHeaderView *vouteHeaderView;

//FeedDetailTableViewCommentCellIdentifier
@property (nonatomic,strong)CommentView * commentView;

//FeedDetailTableViewMoreCommentCellIdentifier
@property (nonatomic,strong)UIView      * commentHeaderView;

@end

@implementation FeedDetailTableViewCell

+ (instancetype)loadCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier{
    FeedDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[FeedDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([reuseIdentifier isEqualToString:FeedDetailTableViewTitleCellIdentifier]) {
            [self.contentView addSubview:self.titleView];
        }
        else if ([reuseIdentifier isEqualToString:FeedDetailTableViewFeedContentCellIdentifier]) {
            [self.contentView addSubview:self.contentImageView];
            [self.contentView addSubview:self.contentLabel];
        }
        else if ([reuseIdentifier isEqualToString:FeedDetailTableViewPointVSCellIdentifier]) {
            [self.contentView addSubview:self.vouteHeaderView];
            WEAKSELF;
            [_vouteHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.contentView.mas_left);
                make.right.equalTo(weakSelf.contentView.mas_right);
                make.top.equalTo(weakSelf.contentView.mas_top);
                make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            }];
        }
        else if ([reuseIdentifier isEqualToString:FeedDetailTableViewCommentHeaderCellIdentifier]) {
            [self.contentView addSubview:self.commentHeaderView];
        }
        else if ([reuseIdentifier isEqualToString:FeedDetailTableViewCommentCellIdentifier]) {
            [self.contentView addSubview:self.commentView];
        }
    }
//    self.textLabel.backgroundColor = [UIColor clearColor];
//    self.imageView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor clearColor];
    return self;
}
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    self.textLabel.backgroundColor = [UIColor clearColor];
//    self.imageView.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor clearColor];
//}
- (void)congfigContentView:(FeedDetailModel *)detailModel {
    
    if ([self.reuseIdentifier isEqualToString:FeedDetailTableViewTitleCellIdentifier]) {
        UILabel *titleLab = [_titleView viewWithTag:1000];
        UIButton *timeButton =[_titleView viewWithTag:1001];
        UIButton *quanziButton = [_titleView viewWithTag:1002];
        JoinCircleButton *joinCircleButton = [_titleView viewWithTag:1003];
        
        titleLab.text = detailModel.title;
        timeButton.hidden = [NSString isBlankString:detailModel.live_time];
        [timeButton setTitle:detailModel.live_time forState:UIControlStateNormal];
        [timeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];

        quanziButton.hidden = [NSString isBlankString:detailModel.circle_name];
        [quanziButton setTitle:detailModel.circle_name forState:UIControlStateNormal];
        
        joinCircleButton.hidden = [NSString isBlankString:detailModel.circle_name];
        joinCircleButton.selected = detailModel.joined;
    }
    else if ([self.reuseIdentifier isEqualToString:FeedDetailTableViewFeedContentCellIdentifier]) {
       
        if ([NSString isBlankString:detailModel.pic]) {
            _contentImageView.frame = CGRectZero;
            _contentImageView.hidden = YES;
            _contentLabel.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, detailModel.contentHeight+20);
            _contentLabel.text = detailModel.desc;

        } else {
            _contentImageView.hidden = NO;
            CGRect frame = self.contentImageView.frame;
            frame.size.height = detailModel.imageHeigth;
            _contentImageView.frame = frame;
            _contentLabel.text = detailModel.desc;
            _contentLabel.frame = CGRectMake(_contentImageView.left, _contentImageView.bottom+10, _contentImageView.width, detailModel.contentHeight);
        }
        for (UIView *view in self.contentView.subviews) {
            NSLog(@"%@ frame is %@",view.class,NSStringFromCGRect(view.frame));
        }
    }
    else if ([self.reuseIdentifier isEqualToString:FeedDetailTableViewPointVSCellIdentifier]) {
        [_vouteHeaderView configSubViewsWithDataModel:detailModel];
    }
    else if ([self.reuseIdentifier isEqualToString:FeedDetailTableViewCommentHeaderCellIdentifier]) {
        UILabel *countLabel = [_commentHeaderView viewWithTag:2000];
        countLabel.text = [NSString stringWithFormat:@"(%d)",[detailModel.commentCount intValue]];
    }
    else if ([self.reuseIdentifier isEqualToString:FeedDetailTableViewCommentCellIdentifier]) {
        [self.contentView addSubview:self.commentView];
    }

}
#pragma mark -- Event Response
- (void)quanZiActionClicked :(UIButton *)sender {
    if ([self.reuseIdentifier isEqualToString:FeedDetailTableViewTitleCellIdentifier]) {
        if (self.pushToCircleHomePage) {
            self.pushToCircleHomePage(sender);
        }
    }
}
- (void)joinAndExitCircleAction:(JoinCircleButton *)sender {
    if ([self.reuseIdentifier isEqualToString:FeedDetailTableViewTitleCellIdentifier]) {
        if (self.joinCircleHandle) {
            self.joinCircleHandle(sender);
        }
    }
}
#pragma mark -- CommentViewDelegate
- (void)commentView:(CommentView *)comentView didClickedDianZanAction:(UIButton *)sender commentModel:(CommentModel *)comment {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailTableViewCell:commentView:didClickedDianZanAction:commentModel:)]) {
        [self.delegate feedDetailTableViewCell:self commentView:comentView didClickedDianZanAction:sender commentModel:comment];
    }
}
#pragma mark -- setter
- (void)setComment:(CommentModel *)comment {
    if ([self.reuseIdentifier isEqualToString:FeedDetailTableViewCommentCellIdentifier]) {
        self.commentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, comment.contentHeight + 60);
        _comment = comment;
        self.commentView.comment = comment;
    }
}
#pragma mark -- getter
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
        _titleView.backgroundColor = [UIColor clearColor];
        //title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 50)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:22];
        titleLabel.numberOfLines = 2;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = 1000;
        [_titleView addSubview:titleLabel];
        //时间
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        timeButton.frame = CGRectMake(10, titleLabel.bottom+8, 185, 22);
        [timeButton setImage:[UIImage imageNamed:@"icon_time.png"] forState:UIControlStateNormal];
        [timeButton setTitleColor:UIRGBColor(135, 135, 135, 1.0f) forState:UIControlStateNormal];
        timeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        timeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        timeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
        timeButton.userInteractionEnabled = NO;
        timeButton.tag = 1001;
        timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_titleView addSubview:timeButton];
        //圈子
        UIButton *quanZiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        quanZiButton.frame = CGRectMake(10, timeButton.bottom +10, SCREEN_WIDTH - 80, 20);
        [quanZiButton setTitleColor:[UIColor colorWithHexstring:@"507daf"] forState:UIControlStateNormal];
        [quanZiButton setImage:[UIImage imageNamed:@"icon_quanzi.png"] forState:UIControlStateNormal];
        quanZiButton.titleLabel.font = [UIFont systemFontOfSize:12];
        quanZiButton.backgroundColor = [UIColor clearColor];
        quanZiButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        quanZiButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        quanZiButton.tag = 1002;
        [quanZiButton addTarget:self action:@selector(quanZiActionClicked:) forControlEvents:UIControlEventTouchUpInside];

        [_titleView addSubview:quanZiButton];
        //加入/未加入按钮
        JoinCircleButton *joinButton =[JoinCircleButton buttonWithType:UIButtonTypeCustom];
        joinButton.frame =  CGRectMake(SCREEN_WIDTH - 75, timeButton.bottom+5, 60, 30);
        joinButton.backgroundColor = [UIColor clearColor];
        joinButton.titleLabel.font = [UIFont systemFontOfSize:13];
        joinButton.selected =NO;
        joinButton.tag = 1003;
        joinButton.layer.borderWidth = 0.8;
        joinButton.layer.masksToBounds = YES;
        joinButton.layer.cornerRadius = 4.0f;
        [joinButton addTarget:self action:@selector(joinAndExitCircleAction:) forControlEvents:UIControlEventTouchUpInside];

        [_titleView addSubview:joinButton];
        
    }
    return _titleView;
}

#pragma mark -- FeedDetailTableViewFeedContentCellIdentifier
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH-20, 200)];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit & UIViewContentModeTopLeft;
        _contentImageView.backgroundColor = [UIColor clearColor];
    }
    return _contentImageView;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contentImageView.left, _contentImageView.bottom+8, SCREEN_WIDTH- 2*_contentImageView.left, 0)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = UIRGBColor(94, 94, 94, 1.0f);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

#pragma mark -- FeedDetailTableViewPointVSCellIdentifier
- (VouteHeaderView *)vouteHeaderView {
    if (!_vouteHeaderView) {
        _vouteHeaderView = [[VouteHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    }
    return _vouteHeaderView;
}
#pragma mark -- FeedDetailTableViewCommentCellIdentifier
- (CommentView *)commentView {
    if (!_commentView) {
        _commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _commentView.delegate = self;
    }
    return _commentView;
}
#pragma mark -- FeedDetailTableViewMoreCommentCellIdentifier
- (UIView *)commentHeaderView {
    if (!_commentHeaderView) {
        _commentHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _commentHeaderView.backgroundColor = [UIColor whiteColor];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(10, 10, 3, 20);
        lineLayer.backgroundColor = [UIColor colorWithHexstring:@"cccccc"].CGColor;
        [_commentHeaderView.layer addSublayer:lineLayer];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 35, 40)];
        tip.text = @"评论";
        tip.textColor = [UIColor colorWithHexstring:@"333333"];
        tip.textAlignment = NSTextAlignmentRight;
        tip.font = [UIFont systemFontOfSize:16];
        [_commentHeaderView addSubview:tip];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(tip.right, 0, 130, 40)];
        countLabel.textColor = [UIColor colorWithHexstring:@"c6c6c6"];
        countLabel.textAlignment = NSTextAlignmentLeft;
        countLabel.font = [UIFont systemFontOfSize:13.5f];
        countLabel.tag = 2000;
        [_commentHeaderView addSubview:countLabel];
    }
    return _commentHeaderView;
}
@end

@implementation JoinCircleButton

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self setTitle:@"已加入" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexstring:@"999999"] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor colorWithHexstring:@"999999"].CGColor;
        
    } else {
        [self setTitle:@"+ 加入" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexstring:@"fe3768"] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor colorWithHexstring:@"fe3768"].CGColor;
    }
}

@end

