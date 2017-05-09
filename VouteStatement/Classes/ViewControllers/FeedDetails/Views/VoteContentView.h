//
//  VoteContentView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDetailModel.h"

extern NSString * const VoteContentViewShowMoreContentStatusDidChangeNotificationName;

@interface VoteContentView : UIView

@property (nonatomic,strong)FeedDetailModel *detailModel;

@property (nonatomic,assign)BOOL    showMoreContent;

@end
