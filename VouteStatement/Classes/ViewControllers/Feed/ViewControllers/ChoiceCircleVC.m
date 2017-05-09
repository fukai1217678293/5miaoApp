//
//  ChoiceCircleVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/5/1.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "ChoiceCircleVC.h"
#import "CircleSearchView.h"
#import "ImagePickerManager.h"
#import "UploadImageApiManager.h"
#import "QZSearchApiManager.h"
#import "AddFeedApiManager.h"
#import "VTLocationManager.h"
#import <UMMobClick/MobClick.h>
#import "QZDesAlertView.h"
#import "PublishFeedTableViewCell.h"
#import "UIImage+Extention.h"
#import "PublishFeedReformer.h"
#import "UploadImageReformer.h"
#import "FeedDetailViewController.h"

@interface ChoiceCircleVC ()<UITableViewDelegate,UITableViewDataSource,VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)CircleSearchView *searchView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIBarButtonItem *rightItem;
@property (nonatomic,strong)ImagePickerManager *imagePickerManager;
@property (nonatomic,strong)UploadImageApiManager *uploadImageApi;
@property (nonatomic,strong)QZSearchApiManager *searchApimanager;
@property (nonatomic,strong)AddFeedApiManager *addApiManager;
@property (nonatomic,copy)NSArray <NSArray *>  *dataSource;
@property (nonatomic,assign)CLLocationCoordinate2D userLocation;
@property (nonatomic,strong)MBProgressHUD *imageUploadHUD;
@property (nonatomic,strong)MBProgressHUD *publishHUD;
@property (nonatomic,assign)BOOL isLocated;
@property (nonatomic,assign)BOOL isFladed;
@property (nonatomic,strong)UIView *sectionHeaderView;
@end

@implementation ChoiceCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加圈子";
    self.showNormalBackButtonItem = YES;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [self.view addSubview:self.tableView];
    self.isFladed = NO;
    WEAKSELF;
    self.backActionhandle = ^(){
        weakSelf.feedModel.circle_hash = @"";
        weakSelf.feedModel.circle_name = @"";
        weakSelf.feedModel.left_option = @"";
        weakSelf.feedModel.right_option= @"";
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark -- Event Response
- (void)publishActionHandle {
    if (self.imageUploadHUD) {
        return;
    }
    if (self.publishHUD) {
        return;
    }
    
    if (self.feedModel.image && [NSString isBlankString:self.feedModel.pic]) {
        self.imageUploadHUD =[self showHUDLoadingWithMessage:@"正在上传图片\n请稍候.." inView:self.view];
        [self.uploadImageApi loadData];
    } else {
        self.publishHUD =[self showHUDLoadingWithMessage:@"正在发布\n请稍候.." inView:self.view];
        if (!self.isLocated) {
            [self startLocation];
            return;
        }
        [self.addApiManager loadData];
    }
}
#pragma mark -- Private Method
- (void)startLocation {
    __weak ChoiceCircleVC * weakSelf = self;
    [[VTLocationManager shareInstance] locationWithSuccessCallback:^(CLLocationCoordinate2D coor) {
        if (weakSelf.isLocated) {
            return ;
        }
        if (!weakSelf.isLocated) {
            weakSelf.userLocation = coor;
            weakSelf.isLocated = YES;
            [weakSelf.addApiManager loadData];
        }
        
    } failCallback:^(NSString *error) {
        if (weakSelf.imageUploadHUD) {
            [weakSelf hiddenHUD:weakSelf.imageUploadHUD];
            weakSelf.imageUploadHUD = nil;
        }
        if (weakSelf.publishHUD) {
            [weakSelf hiddenHUD:weakSelf.publishHUD];
            weakSelf.publishHUD = nil;
        }
        [weakSelf showMessage:error inView:weakSelf.view];
        NSLog(@"%@",error);
    }];
}
- (NSDictionary *)_getParam {
    NSMutableDictionary *param =[ @{@"title":self.feedModel.title,
                                    @"lat":@(_userLocation.latitude),
                                    @"lng":@(_userLocation.longitude)} mutableCopy];
    if (![NSString isBlankString:self.feedModel.left_option]) {
        [param setObject:self.feedModel.left_option forKey:@"left"];
    }else {
        [param setObject:@"赞同" forKey:@"left"];
    }
    if (![NSString isBlankString:self.feedModel.right_option]) {
        [param setObject:self.feedModel.right_option forKey:@"right"];
    }else {
        [param setObject:@"反对" forKey:@"right"];
    }
    if (![NSString isBlankString:self.feedModel.dec]) {
        [param setObject:self.feedModel.dec forKey:@"description"];
    }
    if (![NSString isBlankString:self.feedModel.pic]) {
        [param setObject:self.feedModel.pic forKey:@"pic"];
    }
    if (![NSString isBlankString:self.feedModel.circle_name]) {
        [param setValue:self.feedModel.circle_name forKey:@"circle_name"];
        [param setValue:[NSString isBlankString:self.feedModel.last_hours] ? @"24" : self.feedModel.last_hours forKey:@"last_hour"];
        if (![NSString isBlankString:self.feedModel.circle_hash]) {
            [param setValue:self.feedModel.circle_hash forKey:@"circle_hash"];
        }
    }
    return param;
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if ([manager isKindOfClass:[QZSearchApiManager class]]) {
        return @{@"q":self.feedModel.circle_name};
    }
    else if ([manager isKindOfClass:[UploadImageApiManager class]]) {
        return @{@"image":self.feedModel.image,
                 @"wsfile":@"",
                 @"ftype":@"feed"};
    }
    
    return [self _getParam];
}

#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if ([manager isKindOfClass:[QZSearchApiManager class]]) {
        NSArray *resultArray = [manager fetchDataWithReformer:[[PublishFeedReformer alloc] init]];
        if (resultArray.count) {
            WEAKSELF;
            if (!_searchView) {
                _searchView = [[CircleSearchView alloc] initWithText:self.feedModel.circle_name];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                PublishFeedTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                id keywords = self.dataSource[indexPath.section][indexPath.row][3];
                
                [_searchView setTextDidChangeHandle:^(NSString *text){
                    weakSelf.feedModel.circle_name = text;
                    weakSelf.feedModel.circle_hash = @"";
                    [cell configDataWithPublishModel:weakSelf.feedModel keywords:keywords];
                    [weakSelf.searchApimanager cancelAllRequest];
                    [weakSelf.searchApimanager loadData];
                }];
                [_searchView setSearchViewDidSelectedCircleHandle:^(QZSearchResultModel *model){
                    weakSelf.feedModel.circle_name = model.circle_name;
                    weakSelf.feedModel.circle_hash = model.hash_name;
                    [cell configDataWithPublishModel:weakSelf.feedModel keywords:keywords];
                }];
                [self.view addSubview:_searchView];
            }
            if (_searchView.hidden) {
                _searchView.text = _feedModel.circle_name;
                _searchView.hidden = NO;
            }
            [_searchView reloadTableViewWithDataSource:resultArray];
        }
    }
    else if ([manager isKindOfClass:[UploadImageApiManager class]]) {
        UploadImageReformer * reformer = [[UploadImageReformer alloc] init];
        self.feedModel.pic =  [manager fetchDataWithReformer:reformer];
        [self hiddenHUD:self.imageUploadHUD];
        self.imageUploadHUD = nil;
        [self publishActionHandle];
    }
    else {
        NSString *hash_name = [manager fetchDataWithReformer:[[PublishFeedReformer alloc] init]];
        if (self.publishHUD) {
            [self hiddenHUD:self.publishHUD];
            self.publishHUD = nil;
        }
        [MobClick event:@"create_feed_finish" attributes:@{@"user_hash":[VTAppContext shareInstance].hash_name}];
        [self showMessage:@"发布成功" inView:self.navigationController.view];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            KeyWindow
            UITabBarController * rootVC = (UITabBarController *)window.rootViewController;
            UINavigationController  *selectedNav = [rootVC selectedViewController];
            FeedDetailViewController *detailVC =[[FeedDetailViewController alloc] init];
            detailVC.feed_hash_name = hash_name;
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.loadedShowShareAction = YES;
            [selectedNav pushViewController:detailVC animated:YES];
        }];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    if (self.imageUploadHUD) {
        [self hiddenHUD:self.imageUploadHUD];
        self.imageUploadHUD = nil;
    }
    if (self.publishHUD) {
        [self hiddenHUD:self.publishHUD];
        self.publishHUD = nil;
    }
    if (manager != self.searchApimanager) {
        [self showMessage:manager.errorMessage inView:self.view];
    }
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = self.dataSource[indexPath.section][indexPath.row][1];
    NSString *placeholder = self.dataSource[indexPath.section][indexPath.row][2];
    id keywords = self.dataSource[indexPath.section][indexPath.row][3];
    id minLimits = self.dataSource[indexPath.section][indexPath.row][4];
    id maxLimits = self.dataSource[indexPath.section][indexPath.row][5];
    WEAKSELF;
    PublishFeedTableViewCell *cell = [PublishFeedTableViewCell loadCellWithTableView:tableView reuseIdentifier:identifier];
    [cell configPlaceholder:placeholder minLimitLength:minLimits maxLimitLength:maxLimits];
    [cell configDataWithPublishModel:self.feedModel keywords:keywords];
    [cell configTextChangedHandle:^(NSString *text, NSString *keyword) {
        [weakSelf.feedModel setValue:text forKeyPath:keyword];
        if ([keyword isEqualToString:@"circle_name"]) {
            if (!text.length) {
                [weakSelf.searchApimanager cancelAllRequest];
                weakSelf.isFladed =text.length;
            } else {
//                weakSelf.isFladed =text.length;
                [weakSelf.searchApimanager cancelAllRequest];
                [weakSelf.searchApimanager loadData];
            }
        }
        
    } keywords:keywords];

    [cell setTextInputDidEndEditingHandle:^(UITextView *inputView){
        weakSelf.isFladed =inputView.text.length;
    }];
    //圈子解释弹框
    [cell setDidClickedDesCircleAction:^(UIButton *sender){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[QZDesAlertView manager] showInView:weakSelf.navigationController.view];
        });
    }];
    //选择时间
    [cell setDidClickedHourSelectAction:^(BOOL isSelectLeft){
        NSString *hour = isSelectLeft ? @"8" : @"24";
        [weakSelf.feedModel setValue:hour forKeyPath:keywords];
    }];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_dataSource[indexPath.section][indexPath.row][0] floatValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section ? 40 : 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section) {
        return self.sectionHeaderView;
    }
    return nil;
}
#pragma mark -- setter
- (void)setIsFladed:(BOOL)isFladed {
    if (_isFladed != isFladed ) {
        _isFladed = isFladed;
        if (isFladed) {
            //rowHeight id placeholder  keywords minInputLimitLength maxInputLimitLength
            _dataSource =[@[
                            //section 0
                            @[
                                @[@"65",PublishFeedTableViewCellTypeCircleInput,@"发到哪个圈子？(选填,创建新圈子直接输入圈子名)",@"circle_name",@0,@MAXFLOAT],
                                @[@"80",PublishFeedTableViewCellTypeLasthourInput,@"",@"last_hours",@0,@MAXFLOAT]
                                ],
                            //section 1
                            @[
                                @[@"45",PublishFeedTableViewCellTypePointOptionInput,@[@"第一项(默认赞同)",@"第二项(默认反对)"],@[@"left_option",@"right_option"],@[@1,@1],@[@10,@10]]
                                ]] copy];
        } else {
            //rowHeight id placeholder  keywords
            _dataSource = [@[
                             //section 0
                             @[
                                 @[@"65",PublishFeedTableViewCellTypeCircleInput,@"发到哪个圈子？(选填,创建新圈子直接输入圈子名)",@"circle_name",@0,@MAXFLOAT]
                                 ],
                             //section 1
                             @[
                                 @[@"45",PublishFeedTableViewCellTypePointOptionInput,@[@"第一项(默认赞同)",@"第二项(默认反对)"],@[@"left_option",@"right_option"],@[@1,@1],@[@10,@10]]
                                 ]] copy];
        }
        if (_tableView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }

    }
}
#pragma mark -- getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexstring:@"f5f5f5"];
    }
    return _tableView;
}
- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishActionHandle)];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName,[UIColor colorWithHexstring:@"fe3768"], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    }
    return _rightItem;
}
- (ImagePickerManager *)imagePickerManager {
    if (!_imagePickerManager) {
        _imagePickerManager = [[ImagePickerManager alloc] initWithPresentedViewController:self.navigationController showEditCrop:YES];
        _imagePickerManager.minPhotoWidthSelectable = 600.0f;
        _imagePickerManager.minPhotoHeightSelectable = 338.0f;
    }
    return _imagePickerManager;
}
- (QZSearchApiManager *)searchApimanager {
    if (!_searchApimanager) {
        _searchApimanager = [[QZSearchApiManager alloc] init];
        _searchApimanager.delegate = self;
        _searchApimanager.paramsourceDelegate = self;
    }
    return _searchApimanager;
}
- (UploadImageApiManager *)uploadImageApi {
    if (!_uploadImageApi) {
        _uploadImageApi = [[UploadImageApiManager alloc] init];
        _uploadImageApi.delegate = self;
        _uploadImageApi.paramsourceDelegate = self;
    }
    return _uploadImageApi;
}
- (AddFeedApiManager *)addApiManager {
    if (!_addApiManager) {
        _addApiManager = [[AddFeedApiManager alloc] init];
        _addApiManager.delegate = self;
        _addApiManager.paramsourceDelegate = self;
    }
    return _addApiManager;
}
- (NSArray *)dataSource {
    if (!_dataSource) {
        //rowHeight id placeholder  keywords
//        _dataSource = [@[
//                         @[@"65",PublishFeedTableViewCellTypeCircleInput,@"发到哪个圈子？(选填,创建新圈子直接输入圈子名)",@"circle_name",@0,@MAXFLOAT]
//                         ] copy];
        
        _dataSource = [@[
           //section 0
           @[
              @[@"65",PublishFeedTableViewCellTypeCircleInput,@"发到哪个圈子？(选填,创建新圈子直接输入圈子名)",@"circle_name",@0,@MAXFLOAT]],
           //section 1
           @[
               @[@"45",PublishFeedTableViewCellTypePointOptionInput,@[@"第一项(默认赞同)",@"第二项(默认反对)"],@[@"left_option",@"right_option"],@[@1,@1],@[@10,@10]]
               ]] copy];
        
        
    }
    return _dataSource;
}
- (UIView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _sectionHeaderView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 170)/2.0f, 0, 170, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"自定义投票选项(1-10字)";
        titleLabel.textColor = [UIColor colorWithHexstring:@"666666"];
        [_sectionHeaderView addSubview:titleLabel];
        
        CALayer *line1 = [[CALayer alloc] init];
        line1.frame = CGRectMake(15, 19.5, (SCREEN_WIDTH-170-30)/2.0f, 1);
        line1.backgroundColor = [UIColor colorWithHexstring:@"e1e1e1"].CGColor;
        [_sectionHeaderView.layer addSublayer:line1];
        
        CALayer *line2 = [[CALayer alloc] init];
        line2.frame = CGRectMake(titleLabel.right, 19.5, (SCREEN_WIDTH-170-30)/2.0f, 1);
        line2.backgroundColor = [UIColor colorWithHexstring:@"e1e1e1"].CGColor;
        [_sectionHeaderView.layer addSublayer:line2];
    }
    return _sectionHeaderView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
