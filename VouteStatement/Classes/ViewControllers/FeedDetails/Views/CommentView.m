//
//  CommentView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CommentView.h"
#import <UIImageView+WebCache.h>
#import "UpForCommentApiManager.h"

@interface CommentView ()

@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel     *nameLabel;
@property (nonatomic,strong)UILabel     *contentLabel;
@property (nonatomic,strong)UIButton    *dianzanButton;
@property (nonatomic,strong)UILabel     *releaseTimeLabel;

@end

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
     
        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.dianzanButton];
        [self addSubview:self.releaseTimeLabel];
    }
    return self;
}
#pragma mark -- event response
- (void)dianzanAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentView:didClickedDianZanAction:commentModel:)]) {
        
        [self.delegate commentView:self didClickedDianZanAction:sender commentModel:self.comment];
    }
//    if (self.delegate) {
//        
//    }
//    if (![self.delegate commentView:self validateUpSide:self.comment]) {
//        return;
//    }
//    if (sender.selected) {
//        return;
//    }
//    sender.selected = YES;
//    UpForCommentApiManager * apiManager = [[UpForCommentApiManager alloc] initWithCid:self.comment.cid];
//    apiManager.delegate = self;
//    apiManager.paramsourceDelegate = self;
//    [apiManager loadData];
}
#pragma mark -- VTAPIManagerParamSource

- (void)setComment:(CommentModel *)comment {
    
    _comment = comment;
//    BOOL isPos = [comment.type isEqualToString:@"pos"] ? YES : NO;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            
        }
    }];
    self.nameLabel.text = comment.username;
    self.contentLabel.text = comment.content;
    [self.dianzanButton setTitle:[NSString stringWithFormat:@"%@",comment.up] forState:UIControlStateNormal];
    self.releaseTimeLabel.text = comment.add_date;
    CGFloat contentHeight = comment.contentHeight > 10 ? comment.contentHeight : 10;
    self.dianzanButton.frame = CGRectMake(SCREEN_WIDTH/2.0f, 10, SCREEN_WIDTH/2.0f-10, 30);
    self.headerImageView.frame = CGRectMake(10, self.dianzanButton.top, 30, 30);
    self.nameLabel.frame = CGRectMake(_headerImageView.right+10, self.headerImageView.top, SCREEN_WIDTH-(_headerImageView.right+10), 15);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.releaseTimeLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, self.nameLabel.height);
    self.releaseTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.frame = CGRectMake(50, _headerImageView.bottom+10, SCREEN_WIDTH-65, contentHeight);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
//    else {
//        self.dianzanButton.frame = CGRectMake(SCREEN_WIDTH-40, 10, 30, 30);
//        self.headerImageView.frame = CGRectMake(self.dianzanButton.left-40, self.dianzanButton.top, 30, 30);
//        self.nameLabel.frame = CGRectMake(10, 10, _headerImageView.left - 20, 15);
//        self.nameLabel.textAlignment = NSTextAlignmentRight;
//        self.releaseTimeLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, self.nameLabel.height);
//        self.releaseTimeLabel.textAlignment = NSTextAlignmentRight;
//        self.contentLabel.frame = CGRectMake(40, _headerImageView.bottom+10, SCREEN_WIDTH-50, contentHeight);
//        self.contentLabel.textAlignment = NSTextAlignmentRight;
//
//    }
    if (comment.uped ) {
        self.dianzanButton.selected = YES;
    }
    else {
        self.dianzanButton.selected = NO;
    }
    self.dianzanButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.dianzanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    CGFloat width = [[NSString stringWithFormat:@"%d",[comment.up intValue]] boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]} context:nil].size.width;
    self.dianzanButton.imageEdgeInsets = UIEdgeInsetsMake(0, width, 0, -width);
    self.dianzanButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
//    width = width> 30 ? 30 : width;
//    self.dianzanButton.imageEdgeInsets = UIEdgeInsetsMake(0, 9, 0, -9);
//    self.dianzanButton.titleEdgeInsets = UIEdgeInsetsMake(18 , (30-width)/2.f-self.dianzanButton.currentImage.size.width, -18, self.dianzanButton.currentImage.size.width-(30-width)/2.f);
}
#pragma mark -- getter
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _headerImageView.layer.cornerRadius = 15.0f;
        _headerImageView.layer.masksToBounds= YES;
    }
    return _headerImageView;
}
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = UIRGBColor(110, 110, 110, 1.0f);
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel;
}
- (UILabel *)releaseTimeLabel {
    if (!_releaseTimeLabel) {
        _releaseTimeLabel = [[UILabel alloc] init];
        _releaseTimeLabel.font = [UIFont systemFontOfSize:11.0f];
        _releaseTimeLabel.textColor = UIRGBColor(159, 159, 159, 1.0f);
        _releaseTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _releaseTimeLabel;
}
- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:15.5f];
        _contentLabel.textColor = UIRGBColor(39, 39, 39, 1.0f);
    }
    return _contentLabel;
}
- (UIButton *)dianzanButton {
    if (!_dianzanButton) {
        _dianzanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dianzanButton.backgroundColor = [UIColor clearColor];
        [_dianzanButton setImage:[UIImage imageNamed:@"icon_bigdianzan.png"] forState:UIControlStateNormal];
        [_dianzanButton setImage:[UIImage imageNamed:@"icon_bigdianzanxz.png"] forState:UIControlStateSelected];
        [_dianzanButton setTitleColor:[UIColor colorWithHexstring:@"a0a0a0"] forState:UIControlStateNormal];
        [_dianzanButton setTitleColor:UIRGBColor(249, 0, 66, 1.0f) forState:UIControlStateSelected];
        [_dianzanButton addTarget:self action:@selector(dianzanAction:) forControlEvents:UIControlEventTouchUpInside];
        _dianzanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _dianzanButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _dianzanButton.titleLabel.font = [UIFont systemFontOfSize:11];
        
    }
    return _dianzanButton;
}

@end
