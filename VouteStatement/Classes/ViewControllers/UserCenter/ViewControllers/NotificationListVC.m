//
//  NotificationListVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "NotificationListVC.h"
#import "MyNotificationListApiManager.h"
#import "VTURLResponse.h"
#import "NewNotificationCountApiManager.h"
#import "MyNotificationCollectionCell.h"
#import "NotificationModel.h"
#import "MyListReformer.h"
#import "ReadedAllNoticApiManager.h"
#import "FeedDetailViewController.h"
@interface NotificationListVC ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)MyNotificationListApiManager *apiManager;
@property (nonatomic,strong)NewNotificationCountApiManager *getNotiCountApi;
@property (nonatomic,strong)UICollectionView    *dataCollectionView;
@property (nonatomic,strong)NSMutableArray <NotificationModel *>*dataSource;
@property (nonatomic,strong)ReadedAllNoticApiManager *readedAllNoticApi;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,assign)int page;
@property (nonatomic,assign)int unreadNotificationCount;
@property (nonatomic,strong)MBProgressHUD *clearUnreadHUD;
@end

@implementation NotificationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"我的通知";
    self.showNormalBackButtonItem = YES;
    self.unreadNotificationCount = 0;
    [self.view addSubview:self.dataCollectionView];
}
- (void)headerRefresh {
    if ([self.dataCollectionView.mj_footer isRefreshing]) {
        [self.apiManager cancelAllRequest];
        [self.dataCollectionView.mj_footer endRefreshing];
    }
    if (self.dataCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.dataCollectionView.mj_footer setState:MJRefreshStateIdle];
    }
    self.page = 1;
    [self.getNotiCountApi loadData];
}
- (void)footerRefresh {
    if ([self.dataCollectionView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.dataCollectionView.mj_footer endRefreshing];
        return;
    }
    if (self.dataSource.count) {
        self.page += 1;
    } else {
        self.page = 1;
    }
    [self.dataCollectionView.mj_footer beginRefreshing];
    [self.apiManager loadData];
}
- (void)toMarkReaded {
    self.clearUnreadHUD = [self showHUDLoadingWithMessage:@"" inView:self.view];
    [self.readedAllNoticApi loadData];
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.apiManager) {
        return @{@"page":@(_page)};
    }
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    NSLog(@"%@",manager.response.content);
    if (manager == self.getNotiCountApi) {
        self.unreadNotificationCount = [[manager fetchDataWithReformer:[MyListReformer new]] intValue];
        [self.apiManager loadData];
    } else if(manager == self.apiManager){
        NSArray * callbackFeeds = [manager fetchDataWithReformer:[MyListReformer new]];
        if ([self.dataCollectionView.mj_header isRefreshing]) {
            if (callbackFeeds.count) {
                self.dataSource = [callbackFeeds mutableCopy];
            }
            else {
                [self.dataCollectionView.mj_footer endRefreshingWithNoMoreData];
                [self.dataCollectionView.mj_header endRefreshing];
                return;
            }
        }
        else {
            if (!callbackFeeds.count || !callbackFeeds) {
                [self.dataCollectionView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            else {
                [self.dataSource addObjectsFromArray:callbackFeeds];
            }
        }
        [self.dataCollectionView.mj_header endRefreshing];
        [self.dataCollectionView.mj_footer endRefreshing];
        [self.dataCollectionView reloadData];
    }
    else if (manager == self.readedAllNoticApi) {
        [self.clearUnreadHUD hideAnimated:YES];
        [self.dataCollectionView.mj_header beginRefreshing];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    if (manager == self.readedAllNoticApi) {
        [self.clearUnreadHUD hideAnimated:YES];
    }
    else {
        [self.dataCollectionView.mj_header endRefreshing];
        [self.dataCollectionView.mj_footer endRefreshing];
    }
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyNotificationCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyNotificationCollectionCellTypeFeedContent forIndexPath:indexPath];
    cell.dataModel = self.dataSource[indexPath.item];

    return cell;
}
#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    FeedDetailViewController   * detailVC = [[FeedDetailViewController alloc] init];
    detailVC.feed_hash_name = self.dataSource[indexPath.item].feed_hash;
    [self.navigationController pushViewController:detailVC animated:YES];
    [_dataCollectionView.mj_header beginRefreshing];
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataSource.count) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH, self.dataSource[indexPath.item].contentHeight+20);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.unreadNotificationCount) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (!_headerView) {
            [view addSubview:self.headerView];
        }
        UILabel *countLabel = [_headerView viewWithTag:1001];
        NSString *countString = [NSString stringWithFormat:@"%d",self.unreadNotificationCount];
        NSString *text = [NSString stringWithFormat:@"%@个未读",countString];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributeString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexstring:@"fd5c80"],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, countString.length)];
        countLabel.text = text;
        countLabel.attributedText = attributeString;
        return view;
        
    } else {
        return nil;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.unreadNotificationCount) {
        return CGSizeMake(SCREEN_WIDTH, 55);
    } else {
        return CGSizeZero;
    }
}
#pragma mark -- getter
- (MyNotificationListApiManager *)apiManager {
    if (!_apiManager) {
        _apiManager = [[MyNotificationListApiManager alloc] init];
        _apiManager.delegate = self;
        _apiManager.paramsourceDelegate = self;
    }
    return _apiManager;
}
- (NewNotificationCountApiManager *)getNotiCountApi {
    if (!_getNotiCountApi) {
        _getNotiCountApi = [[NewNotificationCountApiManager alloc] init];
        _getNotiCountApi.delegate = self;
    }
    return _getNotiCountApi;
}
- (ReadedAllNoticApiManager *)readedAllNoticApi {
    if (!_readedAllNoticApi) {
        _readedAllNoticApi = [[ReadedAllNoticApiManager alloc] init];
        _readedAllNoticApi.delegate = self;
    }
    return _readedAllNoticApi;
}
- (UICollectionView *)dataCollectionView {
    if (!_dataCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 8;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 7.0f);
        
        _dataCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _dataCollectionView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        _dataCollectionView.delegate = self;
        _dataCollectionView.dataSource = self;
        [_dataCollectionView registerClass:[MyNotificationCollectionCell class] forCellWithReuseIdentifier:MyNotificationCollectionCellTypeFeedContent];
        [_dataCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _dataCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData ];
        _dataCollectionView.mj_footer = footer;
        [_dataCollectionView.mj_header beginRefreshing];
    }
    return _dataCollectionView;
}
- (NSMutableArray <NotificationModel *>*)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        _headerView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        contentView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:contentView];
        
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0f-0.4, 45)];
        countLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.font = [UIFont systemFontOfSize:16];
        countLabel.backgroundColor = [UIColor whiteColor];
        countLabel.tag = 1001;
        [contentView addSubview:countLabel];
        
        CALayer *line = [[CALayer alloc] init];
        line.frame = CGRectMake(countLabel.right, 10, 0.8, 25);
        line.backgroundColor = [UIColor colorWithHexstring:@"e1e1e1"].CGColor;
        [contentView.layer addSublayer:line];
        
        UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        readButton.frame = CGRectMake(countLabel.right+0.8, 0, SCREEN_WIDTH/2.0f, 45);
        readButton.backgroundColor = [UIColor whiteColor];
        [readButton setTitle:@"全部标为已读" forState:UIControlStateNormal];
        [readButton setTitleColor:[UIColor colorWithHexstring:@"fd5c80"] forState:UIControlStateNormal];
        [readButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [readButton addTarget:self action:@selector(toMarkReaded) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:readButton];
    }
    return _headerView;
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
