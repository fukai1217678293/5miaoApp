//
//  PublishFeedTableViewCell.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/27.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishFeedModel.h"

extern NSString * const PublishFeedTableViewCellTypeTitle ;
extern NSString * const PublishFeedTableViewCellTypeCircleInput;
extern NSString * const PublishFeedTableViewCellTypeLasthourInput;
extern NSString * const PublishFeedTableViewCellTypeDescInput;
extern NSString * const PublishFeedTableViewCellTypePointOptionInput;

typedef void(^TextChangedHandle)(NSString *text,NSString *keyword);
typedef void(^DidSelectedImageBtnHandel)(UIButton *sender);
typedef void(^DidClickedDesCircleActionHandle)(UIButton *sender);
typedef void(^DidClickedHourSelectActionHandle)(BOOL isSelectLeft);
typedef void(^TextInputViewDidEndEditing)(UITextView *inputView);
@interface PublishFeedTableViewCell : UITableViewCell


@property (nonatomic,copy)DidSelectedImageBtnHandel didClickedSelectImageAction;
@property (nonatomic,copy)DidClickedDesCircleActionHandle didClickedDesCircleAction;
@property (nonatomic,copy)DidClickedHourSelectActionHandle didClickedHourSelectAction;
@property (nonatomic,copy)TextInputViewDidEndEditing textInputDidEndEditingHandle;

+ (instancetype)loadCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;
- (void)configDataWithPublishModel:(PublishFeedModel *)feedModel keywords:(id)keyword;
- (void)configPlaceholder:(id)placeholder minLimitLength:(id)minlimits maxLimitLength:(id)maxlimits;
- (void)configTextChangedHandle:(TextChangedHandle)handle keywords:(id)keywords;


@end
