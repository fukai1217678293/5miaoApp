//
//  FeedsListCollectionCell.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedExtentionModel.h"

UIKIT_EXTERN NSString * const FeedListCollectionCellDataDictionaryPicKey;
UIKIT_EXTERN NSString * const FeedListCollectionCellDataDictionaryTitleKey;
UIKIT_EXTERN NSString * const FeedListCollectionCellDataDictionaryLeftTitleKey;
UIKIT_EXTERN NSString * const FeedListCollectionCellDataDictionaryRightTitleKey;

@interface FeedsListCollectionCell : UICollectionViewCell

/*! 包含图片路径(picURL)、标题(title)、左边图标(已包装完成的标题)、右边图标(已包装完成的标题)  !*/
@property (nonatomic,strong)NSDictionary *dataDict;

@property (nonatomic,strong)FeedExtentionModel *feed;

@end
