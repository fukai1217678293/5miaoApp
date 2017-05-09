//
//  MyNotificationCollectionCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyNotificationCollectionCell.h"


NSString *const MyNotificationCollectionCellTypeOperation = @"MyNotificationCollectionCellTypeOperation";
NSString *const MyNotificationCollectionCellTypeFeedContent = @"MyNotificationCollectionCellTypeFeedContent";

@interface MyNotificationCollectionCell ()

@property (nonatomic,strong)NotificationRedPointLabel *titleLabel;
@end

@implementation MyNotificationCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (void)setDataModel:(NotificationModel *)dataModel {
    _dataModel = dataModel;
    self.titleLabel.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, dataModel.contentHeight +20);
    self.titleLabel.textData = dataModel;
}

#pragma mark -- getter
- (NotificationRedPointLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[NotificationRedPointLabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHexstring:@"999999"];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end



@interface MyNotificationOperationCell ()

@property (nonatomic,strong)UIView *headerView;

@end

@implementation MyNotificationOperationCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.headerView];
    }
    return self;
}
- (void)readButtonAction {
    
}

- (void)setCount:(int)count {
    _count = count;
    UILabel *countLabel = [_headerView viewWithTag:1001];
    NSString *countString = [NSString stringWithFormat:@"%d",count];
    NSString *text = [NSString stringWithFormat:@"%@个未读",countString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexstring:@"333333"],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, countString.length)];
    countLabel.text = text;
    countLabel.attributedText = attributeString;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0f-0.4, 45)];
        countLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.font = [UIFont systemFontOfSize:16];
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.tag = 1001;
        [_headerView addSubview:countLabel];
        
        CALayer *line = [[CALayer alloc] init];
        line.frame = CGRectMake(countLabel.right, 10, 0.8, 25);
        line.backgroundColor = [UIColor colorWithHexstring:@"e1e1e1"].CGColor;
        [_headerView.layer addSublayer:line];
        
        UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        readButton.frame = CGRectMake(countLabel.right+0.8, 0, SCREEN_WIDTH/2.0f, 45);
        [readButton setTitle:@"全部标为已读" forState:UIControlStateNormal];
        [readButton setTitleColor:[UIColor colorWithHexstring:@"fd5c80"] forState:UIControlStateNormal];
        [readButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [readButton addTarget:self action:@selector(readButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:readButton];
    }
    return _headerView;
}

@end


@implementation NotificationRedPointLabel

- (void)setTextData:(NotificationModel *)textData {
    _textData = textData;
    NSString *text;
    if (textData.unread) {
        text = [NSString stringWithFormat:@" %@",textData.showTitle];
        textData.titleRange = NSMakeRange(textData.titleRange.location+1, textData.titleRange.length);
    } else {
        text = textData.showTitle;
        
    }
    self.text = text;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexstring:@"333333"],NSForegroundColorAttributeName, nil] range:textData.titleRange];
    if (textData.unread) {
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        textAttachment.image = [UIImage imageNamed:@"icon_dian.png"]; //要添加的图片
        textAttachment.bounds = CGRectMake(0, 0, 8, 8);
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
        [attributeString insertAttributedString:textAttachmentString atIndex:0];
        self.attributedText = attributeString;
    } else {
        self.attributedText = attributeString;
    }
}


@end
