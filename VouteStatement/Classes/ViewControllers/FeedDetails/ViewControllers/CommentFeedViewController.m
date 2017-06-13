//
//  CommentFeedViewController.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CommentFeedViewController.h"
#import "VTTextView.h"
#import "AddCommentApiManager.h"
#import "VTLocationManager.h"
#import <UMMobClick/MobClick.h>

@interface CommentFeedViewController ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UIBarButtonItem *rightItem;
@property (nonatomic,strong)VTTextView *inputView;
@property (nonatomic,strong)AddCommentApiManager *addCommentApi;
@property (nonatomic,assign)BOOL    isLocated;
@property (nonatomic,assign)CLLocationCoordinate2D userLocation;
@property (nonatomic,strong)MBProgressHUD *uploadHUD;
@end

@implementation CommentFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发评论";
    self.showNormalBackButtonItem = YES;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [self.view addSubview:self.inputView];
    [self startLocation];
}
#pragma mark -- Event Response
- (void)publishActionHandle{
    if (self.uploadHUD) {
        return;
    }
    self.uploadHUD = [self showHUDLoadingWithMessage:@"" inView:self.view];
    [self.addCommentApi loadData];
}
#pragma mark -- Private Method
- (void)startLocation {//经纬度可选
    __weak CommentFeedViewController * weakSelf = self;
    [[VTLocationManager shareInstance] locationWithSuccessCallback:^(CLLocationCoordinate2D coor) {
        if (weakSelf.isLocated) {
            return ;
        }
        if (!weakSelf.isLocated) {
            weakSelf.userLocation = coor;
            weakSelf.isLocated = YES;
        }
        
    } failCallback:^(NSString *error) {
       
    }];
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (self.userLocation.latitude > 0.0001) {
        return @{@"content":self.inputView.text,
                 @"lng":@(self.userLocation.longitude),
                 @"lat":@(self.userLocation.latitude)};
    }
    else {
        return @{@"content":self.inputView.text};
    }
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    [MobClick event:@"comment_feed" attributes:@{@"feed_hash":self.feed_hash,@"user_hash":[VTAppContext shareInstance].hash_name}];
    [self.uploadHUD hideAnimated:YES];
    self.uploadHUD = nil;
    [self showMessage:@"发表成功" inView:self.view];
    if (self.publishCommentHandle) {
        self.publishCommentHandle();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    [self.uploadHUD hideAnimated:YES];
    self.uploadHUD = nil;
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark -- getter
- (VTTextView *)inputView {
    if (!_inputView) {
        _inputView = [[VTTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.placeholder = @"请输入评论内容(1000字以内)";
        _inputView.limitLength = 1000;
        _inputView.hiddenTipLimitProgress = YES;
    }
    return _inputView;
}
- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(publishActionHandle)];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName,[UIColor colorWithHexstring:@"fe3768"], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    }
    return _rightItem;
}
- (AddCommentApiManager *)addCommentApi {
    if (!_addCommentApi) {
        _addCommentApi = [[AddCommentApiManager alloc] initWithFid:self.feed_hash];
        _addCommentApi.delegate = self;
        _addCommentApi.paramsourceDelegate = self;
    }
    return _addCommentApi;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
