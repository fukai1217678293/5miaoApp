//
//  QZHomeHeaderView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QZInformationModel.h"

@class QZHomeHeaderView;
@protocol QZHomeHeaderViewDelegate <NSObject>

@optional
- (void)qzHomeHeaderView:(QZHomeHeaderView *)headerView didClickedJoinButton:(UIButton *)button ;

@end


@class QZHomeHeaderViewDelegate;

@interface QZHomeHeaderView : UIView

@property (nonatomic,weak)id <QZHomeHeaderViewDelegate> delegate;

- (void)updateInformationWithDataSource:(QZInformationModel *)model;

@end
