//
//  NotificationModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject

@property (nonatomic,copy)NSString *feed_hash;

//vote ->新投票 comment->新评论 up->新的赞同
@property (nonatomic,copy)NSString *ptype;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,assign)BOOL unread;

@property (nonatomic,copy,readonly)NSString *showTitle;

@property (nonatomic,assign)CGFloat contentHeight;

@property (nonatomic,assign)NSRange titleRange;
/*
 hash = f9QVCOovziP5;
 ptype = comment;
 title = "\U6211\U56e7\U516c\U660e\U516c\U4ea4";
 unread = 0;
 */

@end
