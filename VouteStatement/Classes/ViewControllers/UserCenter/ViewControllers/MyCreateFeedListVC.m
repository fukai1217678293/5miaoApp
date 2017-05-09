//
//  MyCreateFeedListVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyCreateFeedListVC.h"
#import "MyCreateFeedListApiManager.h"
#import "CreateFeedCollectionCell.h"
#import "FeedListReformer.h"
//#import "FeedExtentionModel.h"
#import "MyListReformer.h"
#import "MyCreateListModel.h"
#import "FeedDetailViewController.h"
@interface MyCreateFeedListVC ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView *myCollectionView;

@property (nonatomic,strong)MyCreateFeedListApiManager *createFeedListApiManager;
@property (nonatomic,strong)NSMutableArray <MyCreateListModel *>*dataSource;
@property (nonatomic,strong)NSString    *lastAnchor;

@end

@implementation MyCreateFeedListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationItem];
    [self.view addSubview:self.myCollectionView];
}
- (void)configNavigationItem {
    
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"我的创建";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
}
- (void)headerRefresh {
    
    if ([self.myCollectionView.mj_footer isRefreshing]) {
        
        [self.createFeedListApiManager cancelAllRequest];
        [self.myCollectionView.mj_footer endRefreshing];
    }
    if (self.myCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
        self.myCollectionView.mj_footer.state = MJRefreshStateIdle;
    }

    self.lastAnchor = @"0";
    [self.createFeedListApiManager loadData];
    
}
- (void)footerRefresh {
    
    if ([self.myCollectionView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.myCollectionView.mj_footer endRefreshing];
        return;
    }
    if (self.dataSource.count) {
//        FeedModel *feed = [self.dataSource lastObject];
        self.lastAnchor =[self.dataSource lastObject].fid;
    }
    [self.myCollectionView.mj_footer beginRefreshing];
    [self.createFeedListApiManager loadData];
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    
    return @{@"anchor":self.lastAnchor};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if (manager == self.createFeedListApiManager) {
        
        MyListReformer * refermer = [[MyListReformer alloc] init];
        NSArray <MyCreateListModel *>* callbackFeeds = [manager fetchDataWithReformer:refermer];
        if ([self.myCollectionView.mj_header isRefreshing]) {
            if (callbackFeeds.count) {
                self.dataSource = [callbackFeeds mutableCopy];
            }
            else {
                [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
                [self.myCollectionView.mj_header endRefreshing];
                return;
            }
        }
        else {
            if (!callbackFeeds.count || !callbackFeeds) {
                [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            else {
                [self.dataSource addObjectsFromArray:callbackFeeds];
            }
        }
        [self.myCollectionView.mj_header endRefreshing];
        [self.myCollectionView.mj_footer endRefreshing];
        
        [self.myCollectionView reloadData];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    
    if ([self.myCollectionView.mj_header isRefreshing]) {
        [self.myCollectionView.mj_header endRefreshing];
    }
    if ([self.myCollectionView.mj_footer isRefreshing]) {
        [self.myCollectionView.mj_footer endRefreshing];
    }
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark -- UICollectionViewDataSource 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CreateFeedCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.dataDict = self.dataSource[indexPath.row];
    cell.dataModel = self.dataSource[indexPath.item];
    
    return cell;
}
#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    FeedDetailViewController * detailVC = [[FeedDetailViewController alloc] init];
    detailVC.feed_hash_name = self.dataSource[indexPath.item].hash_name;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataSource.count) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH, self.dataSource[indexPath.item].titleHeight + 90);
}

#pragma mark -- getter
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, 90);
        layout.minimumLineSpacing = 8;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 7.0f);

        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _myCollectionView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerClass:[CreateFeedCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData ];
        _myCollectionView.mj_footer = footer;
        [_myCollectionView.mj_header beginRefreshing];
    }
    return _myCollectionView;
}
- (MyCreateFeedListApiManager *)createFeedListApiManager {
    
    if (!_createFeedListApiManager) {
        _createFeedListApiManager = [[MyCreateFeedListApiManager alloc] init];
        _createFeedListApiManager.delegate = self;
        _createFeedListApiManager.paramsourceDelegate = self;
    }
    return _createFeedListApiManager;
}
- (NSMutableArray <MyCreateListModel *>*)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
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
