//
//  SearchResultVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "SearchResultVC.h"
#import "SearchApiManager.h"
#import "FeedsListCollectionCell.h"
#import "SearchReformer.h"
#import "FeedExtentionModel.h"
#import "FeedDetailsVC.h"

@interface SearchResultVC ()<UICollectionViewDelegate,UICollectionViewDataSource,VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UICollectionView    *resultCollectionView;
@property (nonatomic,strong)SearchApiManager    *searchApi;
@property (nonatomic,strong)NSMutableArray<FeedExtentionModel *>*dataSource;
@property (nonatomic,assign)int                 page;
@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNormalBackButtonItem   = YES;
    self.navigationItem.title       = @"搜索结果";
    self.view.backgroundColor       = UIRGBColor(242, 242, 242, 1.0f);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [self.view addSubview:self.resultCollectionView];
}
#pragma mark --VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    return @{@"q":self.searchKeyword,
             @"page":@(self.page)};
}
#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    NSLog(@"");
    SearchReformer * refermer = [[SearchReformer alloc] init];
    
    NSArray * callbackFeeds = [manager fetchDataWithReformer:refermer];
    
    if ([self.resultCollectionView.mj_header isRefreshing]) {
        
        if (callbackFeeds.count) {
            self.dataSource = [callbackFeeds mutableCopy];
        }
        else {
            [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
            [self.resultCollectionView.mj_header endRefreshing];
            return;
        }
    }
    else {
        if (!callbackFeeds.count || !callbackFeeds) {
            
            [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        else {
            [self.dataSource addObjectsFromArray:callbackFeeds];
        }
    }
    if ([self.resultCollectionView.mj_header isRefreshing]) {
        [self.resultCollectionView.mj_header endRefreshing];
    }
    if ([self.resultCollectionView.mj_footer isRefreshing]) {
        [self.resultCollectionView.mj_footer endRefreshing];
    }
    
    [self.resultCollectionView reloadData];
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    if ([self.resultCollectionView.mj_header isRefreshing]) {
        [self.resultCollectionView.mj_header endRefreshing];
    }
    if ([self.resultCollectionView.mj_footer isRefreshing]) {
        [self.resultCollectionView.mj_footer endRefreshing];
    }
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark --Event Response
- (void)headerRefresh {
    
    self.page = 1;
    if ([self.resultCollectionView.mj_footer isRefreshing]) {
        
        [self.searchApi cancelAllRequest];
        [self.resultCollectionView.mj_footer endRefreshing];
    }
    if (self.resultCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
        self.resultCollectionView.mj_footer.state = MJRefreshStateIdle;
    }
    [self.searchApi loadData];
}
- (void)footerRefresh {
    self.page = self.page + 1;
    if ([self.resultCollectionView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.resultCollectionView.mj_footer endRefreshing];
        return;
    }
    [self.resultCollectionView.mj_footer beginRefreshing];
    [self.searchApi loadData];
}
#pragma mark --UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedsListCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataSource.count) {
        cell.feed = self.dataSource[indexPath.row];
    }
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
- (UICollectionView *)resultCollectionView {
    if (!_resultCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, 90);
        layout.minimumLineSpacing = 8;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 7.0f);
        
        _resultCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _resultCollectionView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        _resultCollectionView.delegate = self;
        _resultCollectionView.dataSource = self;
        [_resultCollectionView registerClass:[FeedsListCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _resultCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData ];
        _resultCollectionView.mj_footer = footer;
        [_resultCollectionView.mj_header beginRefreshing];

    }
    return _resultCollectionView;
}
- (SearchApiManager *)searchApi {
    if (!_searchApi) {
        _searchApi = [[SearchApiManager alloc] init];
        _searchApi.delegate = self;
        _searchApi.paramsourceDelegate = self;
    }
    return _searchApi;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
