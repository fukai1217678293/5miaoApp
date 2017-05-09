//
//  HomeFindCollectionCell.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/15.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedModel.h"

@class QZFindCollectionCell;
@protocol QZFindCollectionCellDelegate <NSObject>

@optional
- (void)qzFindCollectionCell:(QZFindCollectionCell *)cell didClieckedQZActionWithHashName:(NSString *)hashName;

@end

@class QZFindCollectionCellDelegate;

@interface QZFindCollectionCell : UICollectionViewCell

@property (nonatomic,strong)FeedModel *feedModel;

@property (nonatomic,strong)UIImageView *bgImgView;

@property (nonatomic,weak)id <QZFindCollectionCellDelegate> delegate;
@end
