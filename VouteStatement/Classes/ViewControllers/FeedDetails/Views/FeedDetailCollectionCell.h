//
//  FeedDetailCollectionCell.h
//  VouteStatement
//
//  Created by 付凯 on 2017/5/10.
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
extern NSString * const FeedDetailTableViewVotedCountHeaderCellIdentifier;
extern NSString * const FeedDetailTableViewCommentHeaderCellIdentifier;
extern NSString * const FeedDetailTableViewCommentCellIdentifier;

@class FeedDetailCollectionCell;
@protocol FeedDetailTableViewCellDelegate <NSObject>

@optional
- (void)feedDetailTableViewCell:(FeedDetailCollectionCell *)cell
                  voteCountView:(VoteCountVSView *)voteCountView
               didClickedToVote:(UIButton *)sender;


- (void)feedDetailTableViewCell:(FeedDetailCollectionCell *)cell
                    commentView:(CommentView *)commentView
        didClickedDianZanAction:(UIButton *)sender
                   commentModel:(CommentModel *)comment;

@end

@class FeedDetailTableViewCellDelegate;

typedef void(^FeedDetailCellTitleViewDidClickedButton)(UIButton *sender);

@interface FeedDetailCollectionCell : UICollectionViewCell

//@property (nonatomic,strong)FeedDetailModel *feedDetailModel;
@property (nonatomic,strong)CommentModel * comment;
@property (nonatomic,assign)BOOL    showMoreContent;
@property (nonatomic,strong)id <FeedDetailTableViewCellDelegate> delegate;
@property (nonatomic,strong)UIImageView *contentImageView;
@property (nonatomic,copy)FeedDetailCellTitleViewDidClickedButton joinCircleHandle;
@property (nonatomic,copy)FeedDetailCellTitleViewDidClickedButton pushToCircleHomePage;
- (void)congfigContentView:(FeedDetailModel *)detailModel;

@end

@interface JoinCircleButton : UIButton


@end
