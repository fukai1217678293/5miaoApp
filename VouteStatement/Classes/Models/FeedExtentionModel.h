//
//  FeedExtentionModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/2/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedModel.h"

@interface FeedExtentionModel : FeedModel

//@property (nonatomic,copy)NSString *all_vote;

@property (nonatomic,copy)NSString *neg_vote;

@property (nonatomic,copy)NSString *pos_vote;

@property (nonatomic,copy)NSString *side;

@property (nonatomic,copy)NSString *voted;

@end
