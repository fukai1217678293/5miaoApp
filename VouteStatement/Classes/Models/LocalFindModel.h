//
//  LocalFindModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalFindModel : NSObject

/*
 "all_vote": 44,
 "hash": "GtBLvHni9lEg",
 "title": " 喜欢周星驰么？",
 "pic": "https://f1cdn.anyknew.com/comm/8/da/0a42ebff8fa404676a693daaf0e0a_600.jpg",
 "id": 905,
 "nearby": true

 */
@property(nonatomic,copy)NSString *all_vote;

@property(nonatomic,copy)NSString *hash_name;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *pic;

@property(nonatomic,copy)NSString *fid;

@property(nonatomic,assign)BOOL isNearby;

@property (nonatomic,assign,readonly)CGFloat titleHeight;

@property (nonatomic,assign,readonly)BOOL isHaveImageURL;

@property (nonatomic,assign)CGFloat imageHeight;

@end
