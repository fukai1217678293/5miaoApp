//
//  MoreCommentVC.h
//  VouteStatement
//
//  Created by 付凯 on 2017/2/6.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreCommentVC : BaseViewController

//话题 id
@property (nonatomic,strong)NSString *fid;
//投票方 yes or no
@property (nonatomic,strong)NSString *side;
//评论总数
@property (nonatomic,assign)int totalCommentCount;

@end
