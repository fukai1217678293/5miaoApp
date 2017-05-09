//
//  VoteCountVSView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDetailModel.h"

@class VoteCountVSView;
@protocol VoteCountVSViewDelegate <NSObject>

@optional
- (void)voteCountVSView:(VoteCountVSView *)toVoteVSView didClickedToVote:(UIControl *)sender;

@end

@class VoteCountVSViewDelegate;

@interface VoteCountVSView : UIView

@property (nonatomic,strong)FeedDetailModel *feedDetailModel;

@property (nonatomic,weak)id <VoteCountVSViewDelegate> delegate;

@end
