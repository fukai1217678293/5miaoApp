//
//  FeedDetailTableViewCell.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDetailModel.h"
#import "CommentModel.h"
#import "VoteCountVSView.h"
#import "CommentView.h"

extern NSString * const FeedDetailTableViewTitleCellIdentifier;
extern NSString * const FeedDetailTableViewFeedContentCellIdentifier;
extern NSString * const FeedDetailTableViewPointVSCellIdentifier;
extern NSString * const FeedDetailTableViewCommentHeaderCellIdentifier;
extern NSString * const FeedDetailTableViewCommentCellIdentifier;

@class FeedDetailTableViewCell;

@protocol FeedDetailTableViewCellDelegate <NSObject>

@optional
- (void)feedDetailTableViewCell:(FeedDetailTableViewCell *)cell
                  voteCountView:(VoteCountVSView *)voteCountView
               didClickedToVote:(UIButton *)sender;


- (void)feedDetailTableViewCell:(FeedDetailTableViewCell *)cell
                    commentView:(CommentView *)commentView
        didClickedDianZanAction:(UIButton *)sender
                   commentModel:(CommentModel *)comment;

@end


@class FeedDetailTableViewCellDelegate;
@class JoinCircleButton;

typedef void(^FeedDetailCellTitleViewDidClickedButton)(UIButton *sender);

@interface FeedDetailTableViewCell : UITableViewCell

+ (instancetype)loadCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,strong)FeedDetailModel *feedDetailModel;
@property (nonatomic,strong)CommentModel * comment;
//@property (nonatomic,assign)BOOL    showVoteFilterSwitch;
@property (nonatomic,assign)BOOL    showMoreContent;
@property (nonatomic,strong)id <FeedDetailTableViewCellDelegate> delegate;
@property (nonatomic,strong)UIImageView *contentImageView;
@property (nonatomic,copy)FeedDetailCellTitleViewDidClickedButton joinCircleHandle;
@property (nonatomic,copy)FeedDetailCellTitleViewDidClickedButton pushToCircleHomePage;
- (void)congfigContentView:(FeedDetailModel *)detailModel;

@end

@interface JoinCircleButton : UIButton


@end
