//
//  VouteHeaderView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDetailModel.h"

struct VouteHeaderViewState {
    BOOL VouteHeaderViewStateWillShowYesState;
    BOOL VouteHeaderViewStateWillShowNoState;
    
};
typedef struct VouteHeaderViewState VouteHeaderViewState;

extern NSString * const VouteHeaderViewFilterDidClickedNotificationName;


@interface VouteHeaderView : UIView

@property (nonatomic,assign)BOOL isVoted;

@property (nonatomic,assign)VouteHeaderViewState vouteHeaderState;

- (void)configSubViewsWithDataModel:(FeedDetailModel *)dataModel;

@end
