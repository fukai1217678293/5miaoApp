//
//  FeedDetailModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/28.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseModel.h"
#import "CommentModel.h"

@interface FeedDetailModel : BaseModel

@property  (nonatomic,copy)NSString *all_vote;

@property  (nonatomic,copy)NSString *circle_hash;

@property (nonatomic,copy)NSString *circle_name;

@property  (nonatomic,copy)NSString *comment;

@property  (nonatomic,copy)NSString *desc;

@property  (nonatomic,copy)NSString *feed_hash_name;

@property  (nonatomic,copy)NSString *left_option;

@property  (nonatomic,copy)NSString *live_time;

@property  (nonatomic,copy)NSString *pic;

@property  (nonatomic,copy)NSString *right_option;

@property  (nonatomic,copy)NSString *share_desc;

@property  (nonatomic,copy)NSString *share_link;

@property  (nonatomic,copy)NSString *share_pic;

@property  (nonatomic,copy)NSString *share_title;

@property  (nonatomic,copy)NSString *title;

@property  (nonatomic,assign)BOOL voted;

@property  (nonatomic,assign)BOOL joined;

@property  (nonatomic,assign,readonly)BOOL haveContent;

@property (nonatomic,strong)NSString *left_vote;

@property (nonatomic,strong)NSString *right_vote;

@property (nonatomic,strong)NSString *side;

@property (nonatomic,strong)NSString *commentCount;

@property (nonatomic,assign)CGFloat contentHeight;

@property (nonatomic,assign)CGFloat imageHeigth;


@end
