//
//  AddCommentVC.h
//  VouteStatement
//
//  Created by 付凯 on 2017/2/6.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseViewController.h"

extern NSString * const AddCommentViewControllerDidSubmitNewCommentNotificationName;

@interface AddCommentVC : BaseViewController

//话题 id
@property (nonatomic,strong)NSString *fid;
//投票方 yes or no
@property (nonatomic,strong)NSString *side;

@end
