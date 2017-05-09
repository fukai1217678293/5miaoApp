//
//  CommentView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
@class CommentView;

@protocol CommentViewDelegate <NSObject>

@optional

- (BOOL)commentView:(CommentView *)commentView validateUpSide:(CommentModel *)comment;

- (void)commentView:(CommentView *)comentView didClickedDianZanAction:(UIButton *)sender commentModel:(CommentModel *)comment;

@end

@class CommentViewDelegate;

@interface CommentView : UIView

@property (nonatomic,strong)CommentModel *comment;

@property (nonatomic,weak) id <CommentViewDelegate> delegate;

@end
