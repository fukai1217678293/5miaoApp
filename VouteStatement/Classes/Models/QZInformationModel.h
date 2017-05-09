//
//  QZInformationModel.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZInformationModel : NSObject

@property (nonatomic,copy)NSString *circle_name;

@property (nonatomic,copy)NSString *circle_hash;

@property (nonatomic,assign)BOOL joined;

@property (nonatomic,copy)NSString *share_desc;

@property (nonatomic,copy)NSString *share_link;

@property (nonatomic,copy)NSString *share_pic;

@property (nonatomic,copy)NSString *share_title;

@end
