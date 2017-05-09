//
//  CommentFeedViewController.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CommentFeedViewControllerDidPublishComment)(void);
@interface CommentFeedViewController : BaseViewController

@property (nonatomic,copy)NSString *feed_hash;
@property (nonatomic,copy)CommentFeedViewControllerDidPublishComment publishCommentHandle;

@end
