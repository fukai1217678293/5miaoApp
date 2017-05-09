//
//  CircleSearchView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/29.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QZSearchResultModel.h"

typedef void(^CircleSearchViewWillHiddenActionHandle)(QZSearchResultModel *resultModel);
typedef void(^CircleSearchViewTextDidChangedHandle)(NSString *text);
typedef void(^CircleSearchViewDidSelectedCircleHandle)(QZSearchResultModel *model);
@interface CircleSearchView : UIView

@property (nonatomic,copy)CircleSearchViewWillHiddenActionHandle hiddenActionHandle;
@property (nonatomic,copy)CircleSearchViewTextDidChangedHandle textDidChangeHandle;
@property (nonatomic,copy)CircleSearchViewDidSelectedCircleHandle searchViewDidSelectedCircleHandle;
@property (nonatomic,copy)NSString *text;
- (instancetype)initWithResultList:(NSArray *)resultList text:(NSString *)text;
- (instancetype)initWithText:(NSString *)text ;
- (void)hidden;
- (void)reloadTableViewWithDataSource:(NSArray *)dataSource;
@end
