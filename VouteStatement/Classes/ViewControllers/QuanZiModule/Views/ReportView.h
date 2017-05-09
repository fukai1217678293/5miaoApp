//
//  ReportView.h
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReportViewActionClickHandle)(NSInteger index);

typedef NS_ENUM(NSUInteger,NSReportType) {
    NSReportTypeWithQuanZi = 0,
    NSReportTypeWithFeed,
};

@interface ReportView : UIView

@property (nonatomic,copy)ReportViewActionClickHandle actionClickedHandle;

- (instancetype)initWithReportType:(NSReportType)type;

- (void)showInView:(UIView *)view;

- (void)hidden;
@end
