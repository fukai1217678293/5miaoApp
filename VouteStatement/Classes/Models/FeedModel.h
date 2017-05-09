//
//  FeedModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/15.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseModel.h"

@interface FeedModel : BaseModel
/*
 "all_vote": 0,
 "live_time": "将要消失",
 "title": "景甜真TM帅",
 "pic": null,
 "feed_hash": "njeg1EAISwzY",
 "circle_hash": "OaIAHD6lot5X",
 "circle_name": "Web"
 */
@property (nonatomic,copy)NSString *fid;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *pic;

@property (nonatomic,copy)NSString *feed_hash;

@property (nonatomic,copy)NSString *all_vote;

@property (nonatomic,copy)NSString *circle_name;

@property (nonatomic,copy)NSString *live_time;

@property (nonatomic,copy)NSString *circle_hash;

@property (nonatomic,assign,readonly)CGFloat titleHeight;

@property (nonatomic,assign)CGFloat imageHeight;


@property (nonatomic,assign,readonly)BOOL isHaveImageURL;

@end


