//
//  QZSearchResultTableViewCell.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/29.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZSearchResultTableViewCell.h"

@interface QZSearchResultTableViewCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *iconButton;

@end

@implementation QZSearchResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexstring:@"f5f5f5"];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconButton];
    }
    return self;
}
#pragma mark -- setter
- (void)setDataModel:(QZSearchResultModel *)dataModel {
    _dataModel = dataModel;
    self.titleLabel.text = dataModel.circle_name;
}
#pragma mark -- getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 80, 60)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHexstring:@"474747"];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}
- (UIButton *)iconButton {
    if (!_iconButton) {
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake(SCREEN_WIDTH-60, 0, 60, 60);
        _iconButton.userInteractionEnabled = NO;
        [_iconButton setImage:[UIImage imageNamed:@"icon_quanzidark.png"] forState:UIControlStateNormal];
        [_iconButton setTitle:@"圈子" forState:UIControlStateNormal];
        [_iconButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_iconButton setTitleColor:[UIColor colorWithHexstring:@"cacaca"] forState:UIControlStateNormal];
        [_iconButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [_iconButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _iconButton;
}
@end
