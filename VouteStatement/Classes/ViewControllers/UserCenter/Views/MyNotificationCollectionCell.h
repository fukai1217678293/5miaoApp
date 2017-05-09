//
//  MyNotificationCollectionCell.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationModel.h"

extern NSString *const MyNotificationCollectionCellTypeOperation;
extern NSString *const MyNotificationCollectionCellTypeFeedContent;

@interface MyNotificationCollectionCell : UICollectionViewCell

@property (nonatomic,strong)NotificationModel *dataModel;


@end

@interface MyNotificationOperationCell : UICollectionViewCell

@property (nonatomic,assign)int count;

@end


@interface NotificationRedPointLabel : UILabel

@property (nonatomic,strong)NotificationModel *textData;

@end
