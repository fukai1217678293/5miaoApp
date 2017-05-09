//
//  MyJoinQZListModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyJoinQZListModel : NSObject

@property (nonatomic,copy)NSString *circle_name;

@property (nonatomic,copy)NSString *hash_name;

@property (nonatomic,assign)BOOL unread;

@property (nonatomic,assign,readonly)CGFloat cellHeight;

@end
