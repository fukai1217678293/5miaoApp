//
//  VottingView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/1.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "VottingView.h"
#import "AddVouteApiManager.h"
#import "FeedVouteReformer.h"
#import <UMMobClick/MobClick.h>

static NSInteger const clickButtonBaseTag = 1010;
static NSInteger const titleScoreLabelBaseTag = 1020;
static NSInteger const countdownImageViewBaseTag = 1030;

@interface VottingView ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UIView  *innerView;

@property (nonatomic,strong)UIView * contentView;
//是否已经点击投票过
@property (nonatomic,assign)BOOL isVouted;
//控制只能投票一方
@property (nonatomic,assign)BOOL isVouteToYes;

@property (nonatomic,strong)NSTimer * timer;

@property (nonatomic,assign)NSTimeInterval currentCountdown;
//点击次数
@property (nonatomic,assign)int clickCountdown;

@property (nonatomic,strong)AddVouteApiManager *apiManager;

//@property (nonatomic,strong)PostTagApiManager *postTagApiManager;

@property (nonatomic,strong)NSString *postTag;

@property (nonatomic,strong)MBProgressHUD         *showHUD;
@property (nonatomic,strong)FeedDetailModel *dataModel;
@end

@implementation VottingView
- (instancetype)initWithDataModel:(FeedDetailModel *)dataModel {
    if (self = [self init]) {
        self.dataModel = dataModel;
    }
    return self;
}
- (instancetype)init {
    
    if (self = [super init]) {
        self.currentCountdown = 5.0f;
        _clickCountdown = 0;
        self.isVouted = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75f];
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return self;
}
#pragma mark -- public method
- (void)showInView:(UIView *)view {
    [view addSubview: self];
    [view addSubview:self.innerView];
    [UIView animateWithDuration:0.15 animations:^{
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    CGRect frame = _innerView.frame;
    frame.origin.y = SCREEN_HEIGHT - 350;
    
    [UIView animateWithDuration:0.15 delay:0.20 usingSpringWithDamping:0.5f initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _innerView.frame = frame;

    } completion:^(BOOL finished) {
        
    }];

}
- (void)hidden {
    
    CGRect frame = _innerView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    
    [UIView animateWithDuration:0.15 animations:^{
        
        _innerView.frame = frame;
    }];
    [UIView animateWithDuration:0.15 delay:0.15 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        [self removeFromSuperview];
    }];
}
#pragma mark -- action method
- (void)vouteClicked:(UIButton *)sender {
    
    if (!_isVouted) {
        _isVouted = YES;
        self.isVouteToYes = !(sender.tag - clickButtonBaseTag);
        [self.timer fireDate];
    }
    if (_currentCountdown == 0) {
        return;
    }
    if ((sender.tag - clickButtonBaseTag) != self.isVouteToYes) {
        self.clickCountdown++;
    }
    else {
        //只能点击一方
    }
}
- (void)closeActionClicked {
    if (_isVouted) {//提前结束
        if (_timer) {
            [self.timer invalidate];
            self.timer = nil;
            UIWindow * window = [UIApplication sharedApplication].delegate.window;
            self.showHUD = [self.presentViewController showHUDLoadingWithMessage:@"提交您的票数中.." inView:window];
            [self.apiManager loadData];
        }
        else {
            [self hidden];
        }
    }
    else {
        [self hidden];
    }
}
- (void)shareClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(vottingView:didClickedShareItem:)]) {
        [self hidden];
        [_delegate vottingView:self didClickedShareItem:sender.tag-100];
    }
}
- (void)countdown {
    if (self.currentCountdown == 0) {
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        self.showHUD = [self.presentViewController showHUDLoadingWithMessage:@"提交您的票数中.." inView:window];
        [self.apiManager loadData];
        [self.timer invalidate];
        self.timer = nil;
    }
    else {
        self.currentCountdown --;
        UIImageView * countdownImageView = [self.innerView viewWithTag:countdownImageViewBaseTag];
        [countdownImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_djs%d.png",(int)self.currentCountdown]]];
    }
}
#pragma mark -- private method
- (NSString *)getFormatterScore:(int)score {
    
    NSString * formatterString;
    if (score <10) {
        formatterString = [NSString stringWithFormat:@"00%d",score];
    }
    else if (score < 100 && score >= 10){
        formatterString = [NSString stringWithFormat:@"0%d",score];
    }
    else {
        formatterString = [NSString stringWithFormat:@"%d",score];
    }
    return formatterString;
}
- (void)layoutVoteSuccessSubViewsWithPosVotes:(int)posvote negVotes:(int)negvote selfVotes:(int)selfVotes{
    for (UIView * subView in _contentView.subviews) {
        [subView removeFromSuperview];
    }
    for (CALayer * sublayer in _contentView.layer.sublayers) {
        [sublayer removeFromSuperlayer];
    }
    CALayer * lineLayer = [[CALayer alloc] init];
    lineLayer.backgroundColor = UIRGBColor(218, 218, 218, 1.0f).CGColor;
    lineLayer.frame = CGRectMake(20, _contentView.height/2.0f-0.5f, _contentView.width-40, 0.5f);
    [_contentView.layer addSublayer:lineLayer];
    
    //分享到
    UILabel *tipLab = ({
        NSString *tipText = [NSString isBlankString:self.dataModel.circle_hash] ? @"分享到" : @"分享，邀请好友加入这个圈子";
        CGSize titleSize = STRING_SIZE(tipText, 12);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_contentView.width/2.0f-titleSize.width/2.0f-5, lineLayer.frame.origin.y-15, titleSize.width+10,30)];
        label.backgroundColor = [UIColor whiteColor];
        label.text  = tipText;
        label.textColor = UIRGBColor(145, 145, 145, 1.0f);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [_contentView addSubview:tipLab];
    
    //vs
    UILabel *vsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contentView.width/2.0f-20, tipLab.top-70, 40, 40)];
    vsLabel.text = @"VS";
    vsLabel.textAlignment = NSTextAlignmentCenter;
    vsLabel.textColor = UIRGBColor(86, 86, 86, 1);
    vsLabel.font = [UIFont systemFontOfSize:25];
    vsLabel.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:vsLabel];
    
    //朋友圈、好友、新浪微博
    NSArray *titles = @[@"QQ好友",@"微信好友",@"微信朋友圈"];
    NSArray *images = @[@"icon_QQ.png",@"icon_weixin.png",@"icon_pyq.png"];
    for (int i = 0; i < 3; i ++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i *70 + (i+1)*(_contentView.width-70*3)/4.0f, tipLab.bottom + 20, 70, 75);
        btn.backgroundColor = [UIColor clearColor];
        UIImage *img = [UIImage imageNamed:images[i]];
        [btn setImage:img forState:UIControlStateNormal];
        [btn setTitleColor:UIRGBColor(130, 130, 130, 1) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0,(70-img.size.width-10)/2.0f, 0, -(70-img.size.width-10)/2.0f);
        btn.titleEdgeInsets = UIEdgeInsetsMake(img.size.height+10, -img.size.width-10, -img.size.height-10, -10);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:btn];
        if (i != 2) {
            
            UILabel *pointScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(i == 0 ? 10: vsLabel.right+15,vsLabel.top-10, vsLabel.left-40, 35)];
            pointScoreLabel.backgroundColor = [UIColor clearColor];
//            pointScoreLabel.textAlignment = i == 0 ? NSTextAlignmentRight : NSTextAlignmentLeft;
            pointScoreLabel.textAlignment = NSTextAlignmentCenter;
            pointScoreLabel.font = [UIFont systemFontOfSize:12];
            pointScoreLabel.textColor = UIRGBColor(121, 120, 121, 1);
            NSString * text = [NSString stringWithFormat:@"%d 票",i == 0 ? posvote : negvote];
            pointScoreLabel.text = text;
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
            UIColor * textColor;
            if (self.isVouteToYes) {
                if (i == 0) {
                    textColor = [UIColor colorWithHexstring:@"fe3768"];
                } else {
                    textColor = [UIColor colorWithHexstring:@"666666"];
                }
            }
            else {
                if (i == 0) {
                    textColor = [UIColor colorWithHexstring:@"666666"];
                } else {
                    textColor = [UIColor colorWithHexstring:@"fe3768"];
                }
            }
            [attr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textColor,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:32],NSFontAttributeName, nil] range:NSMakeRange(0, text.length-1)];
            pointScoreLabel.attributedText = attr;
            
            [_contentView addSubview:pointScoreLabel];
            
            NSString *count = i == 0 ? [NSString stringWithFormat:@"%d",posvote] : [NSString stringWithFormat:@"%d",negvote];
            CGFloat maxWidth = vsLabel.left-40;
            CGFloat width = [count boundingRectWithSize:CGSizeMake(MAXFLOAT,35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:32]} context:nil].size.width;
            width = MIN(width, maxWidth);
            
            //用于计算坐标
            UIView *layer = [[UIView alloc] init];
            layer.frame = CGRectMake(i == 0 ? pointScoreLabel.right -20-width : pointScoreLabel.left, pointScoreLabel.top, width, pointScoreLabel.height);
            layer.backgroundColor = [UIColor clearColor];
            layer.opaque = YES;
            [_contentView addSubview:layer];
            
            NSString *optionText = i ? self.dataModel.right_option : self.dataModel.left_option;
            //option 标题
            UILabel * optionLabel =[[UILabel alloc] initWithFrame:CGRectMake(pointScoreLabel.left ,pointScoreLabel.bottom,pointScoreLabel.width, 20)];
            optionLabel.backgroundColor = [UIColor clearColor];
            optionLabel.textAlignment = NSTextAlignmentCenter;
            optionLabel.textColor = [UIColor colorWithHexstring:@"333333"];
            optionLabel.text = optionText;
            optionLabel.font = [UIFont systemFontOfSize:18];
            optionLabel.tag = titleScoreLabelBaseTag + i;
            optionLabel.adjustsFontSizeToFitWidth = YES;
//            optionLabel.center = CGPointMake(layer.centerX, layer.centerY+25);
            [_contentView addSubview:optionLabel];
            
            if (i == 0) {
                UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, pointScoreLabel.top-45, _contentView.width-20, 20)];
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.text = @"恭喜完成投票";
                titleLabel.textColor = UIRGBColor(61, 61, 61, 1);
                titleLabel.font = [UIFont systemFontOfSize:19];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [_contentView addSubview:titleLabel];
                
                UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.bottom, _contentView.width-20, 20)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.text = [NSString stringWithFormat:@"为%@投了%d票",self.isVouteToYes ? self.dataModel.left_option : self.dataModel.right_option, selfVotes];
                tipLabel.textColor = UIRGBColor(61, 61, 61, 1);
                tipLabel.font = [UIFont systemFontOfSize:13];
                tipLabel.textAlignment = NSTextAlignmentCenter;
                [_contentView addSubview:tipLabel];
            }
        }
    }
}
- (void)layoutBeforeVoteSubViews {
    
    for (UIView * subView in _contentView.subviews) {
        [subView removeFromSuperview];
    }
    for (CALayer * sublayer in _contentView.layer.sublayers) {
        [sublayer removeFromSuperlayer];
    }
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentView.height-80, _contentView.width, 80)];
    tipLab.backgroundColor = [UIColor clearColor];
    NSString * text = @"啊哈你可以按照你的观点强度投票了!点几下,投几票,最多5秒。提前结束请点击右上角关闭按钮";
    tipLab.textColor = UIRGBColor(145, 145, 145, 1.0f);
    tipLab.font = [UIFont systemFontOfSize:13];
    tipLab.numberOfLines = 2;
    tipLab.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIRGBColor(249, 0, 66, 1.0f),NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName, nil] range:NSMakeRange(27, 1)];
    tipLab.attributedText = attr;
    [_contentView addSubview:tipLab];
    
    CALayer * lineLayer = [[CALayer alloc] init];
    lineLayer.backgroundColor = UIRGBColor(218, 218, 218, 1.0f).CGColor;
    lineLayer.frame = CGRectMake(15, tipLab.top-0.5f, _contentView.width-30, 0.5f);
    [_contentView.layer addSublayer:lineLayer];
    
    for (int i = 0 ; i < 2; i ++) {
        VottingHighlightButton * clickButton = [VottingHighlightButton buttonWithType:UIButtonTypeCustom];
        clickButton.frame = CGRectMake(i * 120 + (i+1) * (_contentView.width-240)/3.0f + (i == 0 ? -10 : 10), _contentView.height/2.0f-60, 120, 120);
        clickButton.tag = clickButtonBaseTag + i;
        [clickButton addTarget:self action:@selector(vouteClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:clickButton];
        
        //记分牌
        UILabel * scoreLab =[[UILabel alloc] initWithFrame:CGRectMake(clickButton.left+15, clickButton.top - 45, clickButton.width-30, 30)];
        scoreLab.backgroundColor = [UIColor whiteColor];
        scoreLab.layer.cornerRadius = 15.0f;
        scoreLab.layer.masksToBounds = YES;
        scoreLab.layer.borderColor = UIRGBColor(134, 134, 134, 1.0f).CGColor;
        scoreLab.layer.borderWidth = 0.8f;
        scoreLab.textAlignment = NSTextAlignmentCenter;
        scoreLab.textColor =  UIRGBColor(134, 134, 134, 1.0f);
        scoreLab.text = @"000";
        scoreLab.font = [UIFont boldSystemFontOfSize:21];
        scoreLab.tag = titleScoreLabelBaseTag + i;
        [_contentView addSubview:scoreLab];
        
        //option 标题
        UILabel * optionLabel =[[UILabel alloc] initWithFrame:CGRectMake( scoreLab.left-10, scoreLab.top-35 , scoreLab.width+20 , 30)];
        optionLabel.backgroundColor = [UIColor whiteColor];
        optionLabel.textAlignment = NSTextAlignmentCenter;
        optionLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        optionLabel.text = i ? self.dataModel.right_option : self.dataModel.left_option;
        optionLabel.font = [UIFont systemFontOfSize:18];
        optionLabel.tag = titleScoreLabelBaseTag + i;
        optionLabel.adjustsFontSizeToFitWidth = YES;
        [_contentView addSubview:optionLabel];
        
        //vs
        if (i == 0) {
            
            UILabel * vsLab = [[UILabel alloc] initWithFrame:CGRectMake(clickButton.right, clickButton.top , (_contentView.width-240)/3.0f+20, clickButton.height)];
            vsLab.backgroundColor = [UIColor whiteColor];
            vsLab.text =   @"VS";
            vsLab.font = [UIFont systemFontOfSize:18];
            vsLab.textColor = UIRGBColor(63, 63, 63, 1.0f);
            vsLab.textAlignment = NSTextAlignmentCenter;
            [_contentView addSubview:vsLab];
            
            //计时器
            UIImageView * countdownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_contentView.width/2.0f- 53/2.0f, scoreLab.top-20, 53, 49)];
            [countdownImageView setImage:[UIImage imageNamed:@"icon_djs5.png"]];
            countdownImageView.tag = countdownImageViewBaseTag;
            
            [_contentView addSubview:countdownImageView];

            
        }
    }
}

#pragma mark --VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.apiManager) {
        return @{@"count":@(self.clickCountdown),
                 @"side" :self.isVouteToYes ? @"left":@"right"};
    }
    return @{};
}
#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    FeedVouteReformer * reformer = [[FeedVouteReformer alloc] init];
    NSDictionary * data = [manager fetchDataWithReformer:reformer];
    int negvote = [[data valueForKey:@"right_vote"] intValue];
    int posvote = [[data valueForKey:@"left_vote"] intValue];
//    int self_vote = [[data valueForKey:@"self_vote"] intValue];
    [MobClick event:@"vote_stat" attributes:@{@"feed_hash":self.feed_hash,@"user_hash":[VTAppContext shareInstance].hash_name} counter:self.clickCountdown];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(vottingView:didVotedInSide:posvotes:negvotes:)]) {
            [_delegate vottingView:self didVotedInSide:self.isVouteToYes posvotes:posvote negvotes:negvote];
        }
    }
    [self layoutVoteSuccessSubViewsWithPosVotes:posvote negVotes:negvote selfVotes:self.clickCountdown];
    [self.presentViewController hiddenHUD:self.showHUD];
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    KeyWindow
    [self.presentViewController hiddenHUD:self.showHUD];
    [self.presentViewController showMessage:manager.errorMessage inView:window
     ];
}
#pragma mark -- setter
- (void)setClickCountdown:(int)clickCountdown {
    
    _clickCountdown = clickCountdown;
    
    UILabel * scoreLab = [self.innerView viewWithTag:titleScoreLabelBaseTag+!self.isVouteToYes];
    UIColor * borderColor;
    if (self.isVouteToYes) {
        borderColor = UIRGBColor(233, 171, 42, 1);
    }
    else {
        borderColor = UIRGBColor(20, 146, 121, 1);
    }
    scoreLab.layer.borderColor =borderColor.CGColor;
    scoreLab.textColor = borderColor;
    scoreLab.text = [self getFormatterScore:clickCountdown];
    
}
#pragma mark -- getter
- (UIView *)contentView {
    
    if (!_contentView) {
       _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 305)];
        _contentView.backgroundColor = [UIColor whiteColor];

    }
    return _contentView;
}
- (UIView *)innerView {
    
    if (!_innerView) {
        _innerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 350)];
        _innerView.backgroundColor = [UIColor clearColor];
        [_innerView addSubview:self.contentView];
        
        UIButton *closeBtn = ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            [button setImage:[UIImage imageNamed:@"icon_cha.png"] forState:UIControlStateNormal];
            button.frame = CGRectMake(SCREEN_WIDTH-50, 0, 30, 45);
            [button addTarget:self action:@selector(closeActionClicked) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [_innerView addSubview:closeBtn];
        [self layoutBeforeVoteSubViews];
//        [self layoutVoteSuccessSubViewsWithPosVotes:123 negVotes:123 selfVotes:100];
    }
    return _innerView;
}
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (AddVouteApiManager *)apiManager {
    if (!_apiManager) {
        _apiManager = [[AddVouteApiManager alloc] initWithFid:self.feed_hash];
        _apiManager.delegate = self;
        _apiManager.paramsourceDelegate = self;
    }
    return _apiManager;
}
@end

@implementation VottingHighlightButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    VottingHighlightButton *button = [super buttonWithType:buttonType];
    button.layer.cornerRadius = 60.0f;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithHexstring:@"333333"] forState:UIControlStateNormal];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    button.layer.borderWidth = 0.8f;
    button.highlighted = NO;
    return button;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.layer.borderColor = [UIColor colorWithHexstring:@"fd3768"].CGColor;
        self.backgroundColor = [UIColor colorWithHexstring:@"fd3768"];
    } else {
        self.layer.borderColor = [UIColor colorWithHexstring:@"9a9a9a"].CGColor;
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end

