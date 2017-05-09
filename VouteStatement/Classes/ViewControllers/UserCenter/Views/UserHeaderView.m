//
//  UserHeaderView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/24.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "UserHeaderView.h"
#import <Accelerate/Accelerate.h>
#import <UIButton+WebCache.h>
#import "UIColor+Extention.h"
@interface UserHeaderView ()

@property (nonatomic,strong)UIScrollView    *imageScrollView;
@property (nonatomic,strong)UIImageView     *imageBackgroundView;
@property (nonatomic,strong)UIImageView     *imageView;
@property (nonatomic,strong)UIButton        *headerImageButton;
@property (nonatomic,strong)UILabel         *nameLabel;
@property (nonatomic,strong)UIButton        *dianzanCountButton;
@property (nonatomic,strong)UIButton        *huatiCountButton;
@property (nonatomic,strong)UIButton        *yingxiangliCountButton;

@end

@implementation UserHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configStaticView];
//        [self configViews];
        [self configDatas];
    }
    
    return self;
}
- (void)configStaticView {
    
    self.backgroundColor = [UIColor colorWithHexstring:@"333333"];
    UIImage *image = [UIImage imageNamed:@"header_bg.png"];
    //头像
    self.headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headerImageButton.frame = CGRectMake(self.width/2.0f-50, self.height/2.0f-80, 100, 100);
    self.headerImageButton.layer.cornerRadius = 50.0f;
    self.headerImageButton.layer.masksToBounds= YES;
    [self.headerImageButton setImage:image forState:UIControlStateNormal];
    [self.headerImageButton addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.headerImageButton];
    
    //名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headerImageButton.bottom, self.width, 40)];
    self.nameLabel.text = @"";
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:21];
    [self addSubview:self.nameLabel];
    
//    CGFloat interval_x = 2.0f;
//    
//    CGFloat width = (self.width-1*interval_x)/2.0f;
//    
//    //点赞数、参与话题数、影响力数
//    for (int i = 0; i < 2; i ++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setFrame:CGRectMake(i * width + i * interval_x, self.nameLabel.bottom + 10, width, 18)];
//        button.backgroundColor = [UIColor clearColor];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:13];
//        
////        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * width + i * interval_x, self.nameLabel.bottom + 10, width, 18)];
////        label.backgroundColor = [UIColor clearColor];
////        label.textColor = [UIColor whiteColor];
////        label.font = [UIFont systemFontOfSize:13];
////        label.textAlignment = NSTextAlignmentCenter;
//        CGRect labelFrame = button.frame;
//        
//        if (i == 0) {
//            self.dianzanCountButton = button;
//            labelFrame.origin.x +=15;
//            labelFrame.size.width -= 15;
//        }
//        else if (i == 1){
//            
//            self.huatiCountButton = button;
//        }
//        else if (i == 2){
//            self.yingxiangliCountButton = button;
//            labelFrame.size.width -= 15;
//        }
//        button.frame = labelFrame;
//        
//        
//        [self addSubview:button];
//        
//        if (i != 1) {
//            CALayer * lineLayer = [[CALayer alloc] init];
//            lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
//            lineLayer.frame = CGRectMake(button.right+0.5, self.nameLabel.bottom+10, 1, 18);
//            [self.layer addSublayer:lineLayer];
//        }
//    }
//    [self.huatiCountButton addTarget:self action:@selector(huaTiClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)configViews {
    
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imageScrollView];
    
    UIImage *image = [UIImage imageNamed:@"header_bg.png"];
    //高斯的背景图片
    self.imageBackgroundView = [[UIImageView alloc] initWithFrame:self.imageScrollView.bounds];
    [self setBlurryImage:image];
    self.imageBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageScrollView addSubview:self.imageBackgroundView];
    
    //原图
    self.imageView = [[UIImageView alloc] initWithFrame:self.imageScrollView.bounds];
    self.imageView.image = image;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageScrollView addSubview:self.imageView];
    [self updateHeaderView:CGPointMake(0, 0)];
    
    //头像
    self.headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headerImageButton.frame = CGRectMake(self.width/2.0f-50, self.height/2.0f-80, 100, 100);
    self.headerImageButton.layer.cornerRadius = 50.0f;
    self.headerImageButton.layer.masksToBounds= YES;
    [self.headerImageButton setImage:image forState:UIControlStateNormal];
    [self.headerImageButton addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.headerImageButton];
    
    //名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headerImageButton.bottom, self.width, 40)];
    self.nameLabel.text = @"";
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:21];
    [self addSubview:self.nameLabel];
    
    CGFloat interval_x = 2.0f;
    
    CGFloat width = (self.width-2*interval_x)/2.0f;
    
    //点赞数、参与话题数、影响力数
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i * width + i * interval_x, self.nameLabel.bottom + 10, width, 18)];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        
        //        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * width + i * interval_x, self.nameLabel.bottom + 10, width, 18)];
        //        label.backgroundColor = [UIColor clearColor];
        //        label.textColor = [UIColor whiteColor];
        //        label.font = [UIFont systemFontOfSize:13];
        //        label.textAlignment = NSTextAlignmentCenter;
        CGRect labelFrame = button.frame;
        
        if (i == 0) {
            self.dianzanCountButton = button;
            labelFrame.origin.x +=15;
            labelFrame.size.width -= 15;
        }
        else if (i == 1){
            
            self.huatiCountButton = button;
        }
        else if (i == 2){
            self.yingxiangliCountButton = button;
            labelFrame.size.width -= 15;
        }
        button.frame = labelFrame;
        
        
        [self addSubview:button];
        
        if (i != 2) {
            CALayer * lineLayer = [[CALayer alloc] init];
            lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
            lineLayer.frame = CGRectMake(button.right+0.5, self.nameLabel.bottom+10, 1, 18);
            [self.layer addSublayer:lineLayer];
        }
    }
}
- (void)configDatas {
    
    [self.dianzanCountButton setTitle: @"得赞数 0" forState:UIControlStateNormal ];
    [self.huatiCountButton setTitle: @"参与话题 0" forState:UIControlStateNormal ];
    [self.yingxiangliCountButton setTitle: @"影响力 0" forState:UIControlStateNormal ];
}
#pragma mark -- Event Response
- (void)headerClicked:(UIButton *)sender {
    if (self.headerButtonDidClicked) {
        __block UIButton * blockSender = sender;
        self.headerButtonDidClicked(blockSender);
    }
}
- (void)huaTiClicked:(UIButton *)sender {
    if (self.headerJoinedFeedDidClicked) {
        __block UIButton * blockSender = sender;
        self.headerJoinedFeedDidClicked(blockSender);
    }
}
/**
 *  通过网络请求数据更改显示用户信息
 */
-(void)updateUserInformation:(UserInfoModel *)userModel{
    
    if (userModel) {//查看其他用户
        [self.dianzanCountButton setTitle:[NSString stringWithFormat:@"得赞数 %d",[userModel.up intValue]] forState:UIControlStateNormal];
        
        [self.huatiCountButton setTitle:[NSString stringWithFormat:@"参与话题 %d",[userModel.joined intValue]]  forState:UIControlStateNormal];
        [self.yingxiangliCountButton setTitle:[NSString stringWithFormat:@"影响力 %d",[userModel.impact intValue]] forState:UIControlStateNormal];
        
        NSURL *url = [NSURL URLWithString:userModel.avatar];
        
        WEAKSELF;
        
        [self.headerImageButton sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"header_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
//                [weakSelf setBlurryImage:image];
//                weakSelf.imageView.image = image;
            }
        }];
        self.nameLabel.text = userModel.username;
    }
    else {//本人
        [self.dianzanCountButton setTitle:[NSString stringWithFormat:@"得赞数 %@",[VTAppContext shareInstance].getAgreeCount] forState:UIControlStateNormal];
        
        [self.huatiCountButton setTitle:[NSString stringWithFormat:@"参与话题 %@",[VTAppContext shareInstance].joinedCount]  forState:UIControlStateNormal];
        [self.yingxiangliCountButton setTitle:[NSString stringWithFormat:@"影响力 %@",[VTAppContext shareInstance].impactCount] forState:UIControlStateNormal];
        
        NSURL *url = [NSURL URLWithString:[VTAppContext shareInstance].headerImageUrl];
        
        WEAKSELF;
        
        [self.headerImageButton sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"header_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                [weakSelf setBlurryImage:image];
                weakSelf.imageView.image = image;
            }
        }];
        self.nameLabel.text = [VTAppContext shareInstance].username;
    }
    
   
//    [self.headerImageButton sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"header_bg.png"] options:SDWebImageRetryFailed];
    
}
/**
 *  通过scrollview的滑动改变顶部view的大小和高斯效果
 *
 *  @param offset scrollview下滑的距离
 */
-(void)updateHeaderView:(CGPoint) offset {
    if (offset.y < 0) {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        CGFloat delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.imageScrollView.frame = rect;
        self.clipsToBounds = NO;
        
        self.imageView.alpha = fabs(offset.y / (2 * CGRectGetHeight(self.bounds) / 3));
    }
}


/**
 *  高斯图片
 *
 *  @param originalImage 需要高斯的图片
 */
- (void)setBlurryImage:(UIImage *)originalImage {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurredImage = [self blurryImage:originalImage withBlurLevel:0.9];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.alpha = 0.0;
            self.imageBackgroundView.image = blurredImage;
        });
    });
    
}

/**
 *  高斯背景
 *
 *  @param image    需要高斯模糊的图片
 *  @param blur     高斯模糊的值
 *
 *  @return
 */
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
