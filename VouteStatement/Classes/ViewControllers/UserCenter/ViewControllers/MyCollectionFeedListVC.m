//
//  MyCollectionFeedListVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyCollectionFeedListVC.h"
#import "MyCollectFeedListApiManager.h"
#import "FeedExtentionModel.h"
#import "HomeListRefermer.h"
#import "FeedsListCollectionCell.h"
#import "FeedDetailsVC.h"
@interface MyCollectionFeedListVC ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)MyCollectFeedListApiManager *myCollectApiManager;
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)NSMutableArray <FeedExtentionModel *> *dataSource;
@property (nonatomic,strong)NSString    *lastAnchor;

@end

@implementation MyCollectionFeedListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationItem];
    [self.view addSubview:self.myCollectionView];
}
- (void)configNavigationItem {
    
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"我的收藏";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
}
- (void)headerRefresh {
    
    if ([self.myCollectionView.mj_footer isRefreshing]) {
        
        [self.myCollectApiManager cancelAllRequest];
        [self.myCollectionView.mj_footer endRefreshing];
    }
    if (self.myCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
        self.myCollectionView.mj_footer.state = MJRefreshStateIdle;
    }
    self.lastAnchor = @"0";
//    [self.dataSource removeAllObjects];
    [self.myCollectApiManager loadData];
    
}
- (void)footerRefresh {
    
    if ([self.myCollectionView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.myCollectionView.mj_footer endRefreshing];
        return;
    }
    if (self.dataSource.count) {
//        FeedModel *feed = [self.dataSource lastObject];
//        self.lastAnchor = feed.sourceId;
    }
    [self.myCollectionView.mj_footer beginRefreshing];
    [self.myCollectApiManager loadData];
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
   
    return @{@"anchor":self.lastAnchor};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    
    if (manager == self.myCollectApiManager) {
        
        HomeListRefermer * refermer = [[HomeListRefermer alloc] init];
        
        NSArray * callbackFeeds = [manager fetchDataWithReformer:refermer];
        
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
    FeedsListCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.feed = self.dataSource[indexPath.item];
    return cell;
}
#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    FeedDetailsVC * detailVC = [[FeedDetailsVC alloc] init];
//    detailVC.fid = self.dataSource[indexPath.item].fid;
    [self.navigationController pushViewController:detailVC animated:YES];
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
        [_myCollectionView registerClass:[FeedsListCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData ];
        _myCollectionView.mj_footer = footer;
        [_myCollectionView.mj_header beginRefreshing];
    }
    return _myCollectionView;
}
- (MyCollectFeedListApiManager *)myCollectApiManager {
    if (!_myCollectApiManager) {
        _myCollectApiManager = [[MyCollectFeedListApiManager alloc] init];
        _myCollectApiManager.delegate = self;
        _myCollectApiManager.paramsourceDelegate = self;
    }
    return _myCollectApiManager;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
