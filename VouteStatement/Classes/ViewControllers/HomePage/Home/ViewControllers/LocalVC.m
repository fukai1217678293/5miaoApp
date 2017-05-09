//
//  LocalVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LocalVC.h"
#import "LocalListApiManager.h"
#import "LocalFindCollectionCell.h"
#import <SDWebImageDownloader.h>
#import "HomeListRefermer.h"
#import <SDImageCache.h>
#import "VTLocationManager.h"
#import "FeedWebViewController.h"
#import "FeedDetailsVC.h"
#import "LocalFindModel.h"
#import "FeedDetailViewController.h"
#import "FindDescAlertView.h"

@interface LocalVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UICollectionView *dataCollectionView;
@property (nonatomic,strong)LocalListApiManager * apiManager;
@property (nonatomic,strong)NSMutableArray <LocalFindModel *>*dataSource;
@property (nonatomic,assign)CLLocationCoordinate2D userLocation;
@property (nonatomic,strong)NSString        *lastAnchor;
@property (nonatomic,strong)FindDescAlertView *descAlertView;

@end

@implementation LocalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.dataCollectionView];
    if ([VTAppContext shareInstance].showFindDescAlert) {
        [self.descAlertView showInView:self.view];
    }
}

- (void)startLocation {
    WEAKSELF;
    __block BOOL ret = NO;
    [[VTLocationManager shareInstance] locationWithSuccessCallback:^(CLLocationCoordinate2D coor) {
        if (ret) {
            return;
        }
        ret = YES;
        weakSelf.userLocation = coor;
        weakSelf.lastAnchor = @"0";
        [weakSelf.apiManager loadData];
        if (weakSelf.dataCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
            [weakSelf.dataCollectionView.mj_footer setState:MJRefreshStateIdle];
        }
    } failCallback:^(NSString *error) {
        NSLog(@"%@",error);
        [weakSelf showMessage:error inView:weakSelf.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)headerRefresh {
    if ([self.dataCollectionView.mj_footer isRefreshing]) {
        [self.apiManager cancelAllRequest];
        [self.dataCollectionView.mj_footer endRefreshing];
    }
    [self startLocation];
}
- (void)footerRefresh {
    if ([self.dataCollectionView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.dataCollectionView.mj_footer endRefreshing];
        return;
    }
    if (!self.dataSource.count) {
        [self.dataCollectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    self.lastAnchor =  [self.dataSource lastObject].fid;
    [self.dataCollectionView.mj_footer beginRefreshing];
    [self.apiManager loadData];
}
#pragma mark -- VTAPIManagerParamSource

- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    
    NSDictionary *params = @{};
    
    if (manager == self.apiManager) {
        
        params = @{@"anchor":self.lastAnchor,
                   @"lat":@(self.userLocation.latitude),
                   @"lng":@(self.userLocation.longitude)};
    }
    
    return params;
}

#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    
    NSLog(@"%@",manager.response);
    
    HomeListRefermer * refermer = [[HomeListRefermer alloc] init];
    
    NSArray * callbackFeeds = [self.apiManager fetchDataWithReformer:refermer];
    
    if ([self.dataCollectionView.mj_header isRefreshing]) {
        
        self.dataSource = [callbackFeeds mutableCopy];
    }
    else {
        if (!callbackFeeds.count) {
            [self.dataCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        else {
            
            [self.dataSource addObjectsFromArray:callbackFeeds];
            
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataCollectionView reloadData];
    });
    if ([self.dataCollectionView.mj_header isRefreshing]) {
        [self.dataCollectionView.mj_header endRefreshing];
    }
    if ([self.dataCollectionView.mj_footer isRefreshing]) {
        [self.dataCollectionView.mj_footer endRefreshing];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    
    if ([self.dataCollectionView.mj_header isRefreshing]) {
        [self.dataCollectionView.mj_header endRefreshing];
    }
    if ([self.dataCollectionView.mj_footer isRefreshing]) {
        [self.dataCollectionView.mj_footer endRefreshing];
    }
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LocalFindCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"localFindCell" forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    cell.feedModel = self.dataSource[indexPath.item];
    return cell;
}


#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LocalFindModel * feed = self.dataSource[indexPath.row];
    FeedDetailViewController *detailVC = [[FeedDetailViewController alloc] init];
    detailVC.feed_hash_name = feed.hash_name;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataSource.count) {
        return CGSizeZero;
    }
    
    LocalFindModel * feed = self.dataSource[indexPath.item];
    if (feed.isHaveImageURL) {
        // 先从缓存中查找图片
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: feed.pic];
        CGFloat defaultImageHeight =(SCREEN_WIDTH-20)*9.0f/16.0f;
        // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
        if (!image) {
            feed.imageHeight = defaultImageHeight;
            return CGSizeMake(SCREEN_WIDTH, defaultImageHeight + feed.titleHeight + 60);
        }
        CGSize imageSize = image.size;
        CGSize cellSize;
        cellSize.width = SCREEN_WIDTH;
        CGFloat imageHeight= MAX(imageSize.height*(SCREEN_WIDTH-20)/imageSize.width, defaultImageHeight);
        feed.imageHeight = imageHeight;
        cellSize.height = imageHeight + feed.titleHeight + 60;
        return cellSize;
    } else {
        return CGSizeMake(SCREEN_WIDTH, feed.titleHeight +50);
    }

}
#pragma mark -- private method
- (void)configCell:(LocalFindCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    LocalFindModel * feed = self.dataSource[indexPath.item];
    if (feed.isHaveImageURL) {
        NSString *imgURL = feed.pic;
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
        if ( !cachedImage ) {
            [self downloadImage:imgURL forIndexPath:indexPath];
            [cell.bgImgView setImage:nil];
        } else {
            [cell.bgImgView setImage:cachedImage];
        }
    }
}
- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // do nothing
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        if (!error) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.dataSource.count > indexPath.item) {//
                    if (![self.dataCollectionView.mj_header isRefreshing]) {
                        [self.dataCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                }
            });
        }
    }];
}

#pragma mark -- getter && setter
- (UICollectionView *)dataCollectionView {
    
    if (!_dataCollectionView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 10.0f;
//        CGFloat defaultHeight =SCREEN_WIDTH*9/16.0f;
//        layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH, 60);
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, 30);
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 7.0f);

        _dataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) collectionViewLayout:layout];
        [_dataCollectionView registerClass:[LocalFindCollectionCell class] forCellWithReuseIdentifier:@"localFindCell"];
        _dataCollectionView.delegate = self;
        _dataCollectionView.dataSource= self;
        _dataCollectionView.backgroundColor = [UIColor colorWithHexstring:@"f8f8f8"];
        _dataCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        _dataCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [_dataCollectionView.mj_header beginRefreshing];
    }
    
    return _dataCollectionView;
}

- (LocalListApiManager *)apiManager {
    if (!_apiManager) {
        _apiManager = [[LocalListApiManager alloc] init];
        _apiManager.delegate = self;
        _apiManager.paramsourceDelegate = self;
    }
    return _apiManager;
}
- (FindDescAlertView *)descAlertView {
    if (!_descAlertView) {
        _descAlertView = [[FindDescAlertView alloc] initWithFrame:CGRectMake(10, (SCREEN_HEIGHT-150)/2.0f-64, SCREEN_WIDTH-20, 150)];
    }
    return _descAlertView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
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
