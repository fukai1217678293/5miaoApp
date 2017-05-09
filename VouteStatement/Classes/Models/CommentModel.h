//
//  CommentModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/28.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel

@property (nonatomic,copy)NSString *add_date;
@property (nonatomic,copy)NSString *avatar;
@property (nonatomic,copy)NSString *cid;
@property (nonatomic,copy)NSString *content;
//@property (nonatomic,copy)NSString *pic;
//neg  pos
//@property (nonatomic,copy)NSString *type;
//@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *up;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,assign)BOOL uped;
@property (nonatomic,copy)NSString *user_hash_name;

@property (nonatomic,assign)CGFloat contentHeight;

@end
