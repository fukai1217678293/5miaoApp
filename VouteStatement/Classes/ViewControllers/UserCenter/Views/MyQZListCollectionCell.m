//
//  MyQZListCollectionCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyQZListCollectionCell.h"
#import <Masonry.h>
@interface MyQZListCollectionCell ()

@property(nonatomic,strong)RedPointLabel *titleLabel;

@end

@implementation MyQZListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (void)setData:(MyJoinQZListModel *)data {
    _data = data;
    _titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, data.cellHeight-20);
    _titleLabel.textData = data;
}
#pragma mark -- getter
- (RedPointLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[RedPointLabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
@end


@implementation RedPointLabel

- (void)setTextData:(MyJoinQZListModel *)textData {
    _textData = textData;
    NSString *text = textData.unread ? [NSString stringWithFormat:@" %@",textData.circle_name] : textData.circle_name;
    self.text = text;
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:text attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName,[UIColor colorWithHexstring:@"333333"],NSForegroundColorAttributeName, nil]];
    if (textData.unread) {
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        textAttachment.image = [UIImage imageNamed:@"icon_dian.png"]; //要添加的图片
        textAttachment.bounds = CGRectMake(0, 0, 8, 8);
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
        [att insertAttributedString:textAttachmentString atIndex:0];
        self.attributedText = att;
    } else {
        self.attributedText = attr;
    }
}


@end
