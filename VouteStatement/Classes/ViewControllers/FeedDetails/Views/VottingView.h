//
//  VottingView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/2/1.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FeedDetailModel.h"

@class VottingView;

@protocol VottingViewDelegate <NSObject>

@optional

- (void)vottingView:(VottingView *)voteView didVotedInSide:(int)side posvotes:(int)posVote negvotes:(int)negvote;

- (void)vottingView:(VottingView *)voteView didClickedShareItem:(NSUInteger)sharePlatformOption;

@end

@class VottingViewDelegate;

@interface VottingView : UIView

@property (nonatomic,copy)NSString *feed_hash;

@property (nonatomic,weak) id <VottingViewDelegate> delegate;

@property (nonatomic,strong)BaseViewController *presentViewController;

- (instancetype)initWithDataModel:(FeedDetailModel *)dataModel;

- (void)showInView:(UIView *)view;

- (void)hidden;

@end

@interface VottingHighlightButton : UIButton


@end

