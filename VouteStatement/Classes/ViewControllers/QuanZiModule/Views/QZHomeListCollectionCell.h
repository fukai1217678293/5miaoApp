//
//  QZHomeListCollectionCell.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedModel.h"
#import "QZInformationModel.h"
@interface QZHomeListCollectionCell : UICollectionViewCell

@property (nonatomic,strong)FeedModel *feedModel;

@property (nonatomic,strong)UIImageView *bgImgView;

@end

@protocol QZInformationCollectionCellDelegate;

@interface QZInformationCollectionCell : UICollectionViewCell

@property (nonatomic,strong)QZInformationModel *informationModel;

@property (nonatomic,weak)id <QZInformationCollectionCellDelegate>delegate;

@end


@protocol QZInformationCollectionCellDelegate <NSObject>

@optional
- (void)qzInformationCollectionCell:(QZInformationCollectionCell *)cell didClickedJoinQZButton:(UIButton *)button;

@end
