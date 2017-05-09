//
//  MyQZListCollectionCell.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyJoinQZListModel.h"
@interface MyQZListCollectionCell : UICollectionViewCell

@property (nonatomic,strong)MyJoinQZListModel *data;

@end

@interface RedPointLabel : UILabel 

@property (nonatomic,strong)MyJoinQZListModel *textData;

@end
