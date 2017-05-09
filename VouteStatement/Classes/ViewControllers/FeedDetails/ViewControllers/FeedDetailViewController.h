//
//  FeedDetailViewController.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/29.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^FeedDetailViewControllerLoadCompletionHandle)(void);
@interface FeedDetailViewController : BaseViewController

@property (nonatomic,copy)NSString *feed_hash_name;

@property (nonatomic,copy)FeedDetailViewControllerLoadCompletionHandle viewDidLoadcompletionHandle;

@property (nonatomic,assign)BOOL loadedShowShareAction;

@end
