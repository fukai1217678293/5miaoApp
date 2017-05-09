//
//  MyCreateListModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCreateListModel : NSObject

@property (nonatomic,copy)NSString *all_vote;

@property (nonatomic,copy)NSString *cid;

@property (nonatomic,copy)NSString *hash_name;

@property (nonatomic,copy)NSString *live_time;

@property (nonatomic,copy)NSString *fid;

@property (nonatomic,copy)NSString *left_option;

@property (nonatomic,copy)NSString *left_vote;

@property (nonatomic,copy)NSString *right_option;

@property (nonatomic,copy)NSString *right_vote;

//投票方  left or right
@property (nonatomic,copy)NSString *side;

@property (nonatomic,copy)NSString *title;
//是否已投票
@property (nonatomic,assign)BOOL voted;

@property (nonatomic,copy)NSString *self_vote;

@property (nonatomic,assign,readonly)CGFloat titleHeight;

@end
