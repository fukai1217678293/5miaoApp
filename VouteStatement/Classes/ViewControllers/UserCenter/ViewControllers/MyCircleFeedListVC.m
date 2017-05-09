//
//  MyCircleFeedListVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/23.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MyCircleFeedListVC.h"
#import "MyQZListApiManager.h"
#import "MyQZListCollectionCell.h"
#import "VTURLResponse.h"
#import "MyListReformer.h"
#import "MyJoinQZListModel.h"
#import "QZListVC.h"

@interface MyCircleFeedListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)MyQZListApiManager *apiManager;
@property (nonatomic,strong)UICollectionView    *dataCollectionView;
@property (nonatomic,strong)NSMutableArray  <MyJoinQZListModel *> *dataSource;
@end

@implementation MyCircleFeedListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的圈子";
    self.showNormalBackButtonItem = YES;
    [self.view addSubview:self.dataCollectionView];
}
#pragma mark --VTAPIManagerParamSource 
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    return @{};
}
#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    NSLog(@"%@",manager.response.content);
    MyListReformer * refomer = [[MyListReformer alloc] init];
    self.dataSource = [manager fetchDataWithReformer:refomer];
    [self.dataCollectionView.mj_header endRefreshing];
    [self.dataCollectionView reloadData];
    
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    if ([self.dataCollectionView.mj_header isRefreshing]) {
        [self.dataCollectionView.mj_header endRefreshing];
    }
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyQZListCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.data = self.dataSource[indexPath.item];
    return cell;
}
#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    QZListVC   * listVC = [[QZListVC alloc] init];
    listVC.hash_name = self.dataSource[indexPath.item].hash_name;
    [self.navigationController pushViewController:listVC animated:YES];
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataSource.count) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH, self.dataSource[indexPath.item].cellHeight);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- getter
- (UICollectionView *)dataCollectionView {
    
    if (!_dataCollectionView) {
        WEAKSELF;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.itemSize = CGSizeMake(SCREEN_WIDTH, 90);
        layout.minimumLineSpacing = 8;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 7.0f);
        
        _dataCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _dataCollectionView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        _dataCollectionView.delegate = self;
        _dataCollectionView.dataSource = self;
        [_dataCollectionView registerClass:[MyQZListCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _dataCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.apiManager loadData];
        }];
        [_dataCollectionView.mj_header beginRefreshing];
    }
    return _dataCollectionView;
}
- (MyQZListApiManager *)apiManager {
    if (!_apiManager) {
        _apiManager = [[MyQZListApiManager alloc] init];
        _apiManager.delegate = self;
        _apiManager.paramsourceDelegate = self;
    }
    return _apiManager;
}
- (NSMutableArray <MyJoinQZListModel *>*)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
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
