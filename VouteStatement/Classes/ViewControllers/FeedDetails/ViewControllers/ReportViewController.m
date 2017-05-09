//
//  ReportViewController.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/30.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "ReportViewController.h"
#import "JuBaoApiManager.h"
#import "VTTextView.h"

@interface ReportViewController ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UIBarButtonItem *rightItem;
@property (nonatomic,strong)VTTextView *inputView;
@property (nonatomic,strong)JuBaoApiManager *reportApi;
@property (nonatomic,strong)MBProgressHUD *uploadHUD;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"举报";
    self.showNormalBackButtonItem = YES;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [self.view addSubview:self.inputView];
}
#pragma mark -- Event Response
- (void)publishActionHandle{
    if (self.uploadHUD) {
        return;
    }
    self.uploadHUD = [self showHUDLoadingWithMessage:@"" inView:self.view];
    [self.reportApi loadData];
}

#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    return @{@"reason":self.inputView.text};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    [self.uploadHUD hideAnimated:YES];
    self.uploadHUD = nil;
    [self showMessage:@"举报成功" inView:self.view];
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
        _inputView.placeholder = @"请输入举报原因(6~255字)";
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
- (JuBaoApiManager *)reportApi {
    if (!_reportApi) {
        _reportApi = [[JuBaoApiManager alloc] initWithFid:self.feed_hash];
        _reportApi.delegate = self;
        _reportApi.paramsourceDelegate = self;
    }
    return _reportApi;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
