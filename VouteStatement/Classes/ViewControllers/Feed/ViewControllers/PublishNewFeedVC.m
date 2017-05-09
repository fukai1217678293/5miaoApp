//
//  PublishNewFeedVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/26.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "PublishNewFeedVC.h"
#import "PublishFeedModel.h"
#import "PublishFeedTableViewCell.h"
#import "ImagePickerManager.h"
#import "UIImage+Extention.h"
#import "QZSearchApiManager.h"
#import "PublishFeedReformer.h"
#import "CircleSearchView.h"
#import "QZDesAlertView.h"
#import "UploadImageApiManager.h"
#import "UploadImageReformer.h"
#import "AddFeedApiManager.h"
#import "VTLocationManager.h"
#import "VTURLResponse.h"
#import <UMMobClick/MobClick.h>
#import "FeedDetailViewController.h"
#import "ChoiceCircleVC.h"
@interface PublishNewFeedVC ()<UITableViewDelegate,UITableViewDataSource,VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)PublishFeedModel *feedModel;
@property (nonatomic,copy)NSArray <NSArray *>  *dataSource;
@property (nonatomic,strong)UIButton *rightItem;
@property (nonatomic,assign)BOOL isFladed;
@property (nonatomic,strong)UIView *sectionHeaderView;
@property (nonatomic,strong)ImagePickerManager *imagePickerManager;
@property (nonatomic,strong)UploadImageApiManager *uploadImageApi;
@property (nonatomic,strong)QZSearchApiManager *searchApimanager;
@property (nonatomic,strong)AddFeedApiManager *addApiManager;
@property (nonatomic,strong)CircleSearchView *searchView;
@property (nonatomic,strong)MBProgressHUD *imageUploadHUD;
@property (nonatomic,strong)MBProgressHUD *publishHUD;
@property (nonatomic,assign)BOOL isLocated;
@property (nonatomic,assign)CLLocationCoordinate2D userLocation;
@end

@implementation PublishNewFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"create_feed_start" attributes:@{@"user_hash":[VTAppContext shareInstance].hash_name}];
    self.navigationItem.title = @"创建话题";
    self.showNormalBackButtonItem = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    WEAKSELF;
    self.backActionhandle = ^(){
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    self.isFladed = NO;
    [self.view addSubview:self.tableView];
}
- (void)startLocation {
    __weak PublishNewFeedVC * weakSelf = self;
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

- (void)publishActionHandle {
    if ([PublishFeedModel checkPublishParam:self.feedModel presentVC:self]) {
        ChoiceCircleVC *circleVC = [[ChoiceCircleVC alloc] init];
        circleVC.feedModel = self.feedModel;
        [self.navigationController pushViewController:circleVC animated:YES];
//        if (self.imageUploadHUD) {
//            return;
//        }
//        if (self.publishHUD) {
//            return;
//        }
//        
//        if (self.feedModel.image && [NSString isBlankString:self.feedModel.pic]) {
//            self.imageUploadHUD =[self showHUDLoadingWithMessage:@"正在上传图片\n请稍候.." inView:self.view];
//            [self.uploadImageApi loadData];
//        } else {
//            self.publishHUD =[self showHUDLoadingWithMessage:@"正在发布\n请稍候.." inView:self.view];
//            if (!self.isLocated) {
//                [self startLocation];
//                return;
//            }
//            [self.addApiManager loadData];
//        }
    }
}
/*
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
#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if ([manager isKindOfClass:[QZSearchApiManager class]]) {
        NSArray *resultArray = [manager fetchDataWithReformer:[[PublishFeedReformer alloc] init]];
        if (resultArray.count) {
            WEAKSELF;
            if (!_searchView) {
                _searchView = [[CircleSearchView alloc] initWithText:self.feedModel.circle_name];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                PublishFeedTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                id keywords = self.dataSource[indexPath.row][3];
                
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
            [selectedNav pushViewController:detailVC animated:YES];
        }];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    NSLog(@"%@",manager.response.content);
    if (self.imageUploadHUD) {
        [self hiddenHUD:self.imageUploadHUD];
        self.imageUploadHUD = nil;
    }
    if (self.publishHUD) {
        [self hiddenHUD:self.publishHUD];
        self.publishHUD = nil;
    }
    [self showMessage:manager.errorMessage inView:self.view];
}*/
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = self.dataSource[indexPath.row][1];
    NSString *placeholder = self.dataSource[indexPath.row][2];
    id keywords = _dataSource[indexPath.row][3];
    id minLimits = _dataSource[indexPath.row][4];
    id maxLimits = _dataSource[indexPath.row][5];
    WEAKSELF;
    PublishFeedTableViewCell *cell = [PublishFeedTableViewCell loadCellWithTableView:tableView reuseIdentifier:identifier];
    [cell configPlaceholder:placeholder minLimitLength:minLimits maxLimitLength:maxLimits];
    [cell configDataWithPublishModel:self.feedModel keywords:keywords];
    [cell configTextChangedHandle:^(NSString *text, NSString *keyword) {
        [weakSelf.feedModel setValue:text forKeyPath:keyword];
        if (([keyword isEqualToString:@"title"])) {
            weakSelf.navigationItem.rightBarButtonItem.enabled  = [PublishFeedModel checkPublishParam:weakSelf.feedModel];
        }
        else if ([keyword isEqualToString:@"circle_name"]) {
            [weakSelf.searchApimanager cancelAllRequest];
            [weakSelf.searchApimanager loadData];
        }
    } keywords:keywords];

    //选择图片
    [cell setDidClickedSelectImageAction:^(UIButton *sender){
        [weakSelf.imagePickerManager actionSheetShowInView:self.view];
        weakSelf.imagePickerManager.didSelectedImagehandle = ^(UIImage *image){
            NSData * imageData = UIImageJPEGRepresentation([image fixOrientation], 0.3);
            weakSelf.feedModel.image = [UIImage imageWithData:imageData];
            [sender setImage:image forState:UIControlStateNormal];
        };
    }];
    [cell setTextInputDidEndEditingHandle:^(UITextView *inputView){
        self.isFladed =inputView.text.length;
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
    return [_dataSource[indexPath.row][0] floatValue];
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
    _isFladed = isFladed;
    if (isFladed) {
        //rowHeight id placeholder  keywords minInputLimitLength maxInputLimitLength
        _dataSource =[@[
  @[@"50",PublishFeedTableViewCellTypeTitle,@"添加标题(5-50)",@"title",@5,@50],
  @[@"200",PublishFeedTableViewCellTypeDescInput,@"还有什么想说的?(选填,5000字以内)",@[@"dec",@"image"],@0,@5000]] copy];
    } else {
        //rowHeight id placeholder  keywords
        _dataSource = [
  @[
      @[@"50",PublishFeedTableViewCellTypeTitle,@"添加标题(5-50)",@"title",@5,@50],
      @[@"200",PublishFeedTableViewCellTypeDescInput,@"还有什么想说的?(选填,5000字以内)",@[@"dec",@"image"],@0,@5000]] copy];
    }
    if (_tableView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}
#pragma mark -- getter
- (PublishFeedModel *)feedModel {
    if (!_feedModel) {
        _feedModel = [[PublishFeedModel alloc] init];
    }
    return _feedModel;
}

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
- (UIButton *)rightItem {
    if (!_rightItem) {
        _rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightItem.frame = CGRectMake(0, 0, 60, 30);
        _rightItem.backgroundColor = [UIColor clearColor];
        [_rightItem setTitle:@"下一步" forState:UIControlStateNormal];
        [_rightItem setTitleColor:[UIColor colorWithHexstring:@"b6b6b6"] forState:UIControlStateDisabled];
        [_rightItem setTitleColor:[UIColor colorWithHexstring:@"fe3768"] forState:UIControlStateNormal];
        _rightItem.enabled = NO;
        _rightItem.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightItem addTarget:self action:@selector(publishActionHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
