//
//  FindVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZFindVC.h"
#import "HomeListRefermer.h"
#import "FeedDetailsVC.h"
#import "FeedWebViewController.h"
#import "HomeQuanZiApiManager.h"
#import "QZFindCollectionCell.h"
#import "QZListVC.h"
#import "FeedDetailViewController.h"
#import <SDImageCache.h>
#import "FeedModel.h"
#import <SDWebImageDownloader.h>

@interface QZFindVC ()<VTAPIManagerParamSource,VTAPIManagerCallBackDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,QZFindCollectionCellDelegate>

@property (nonatomic,strong)UICollectionView    *dataCollectionView;
@property (nonatomic,strong)HomeQuanZiApiManager*listApiManager;
@property (nonatomic,strong)NSMutableArray <FeedModel *>*dataSource;
@property (nonatomic,strong)NSString            *lastAnchor;
@property (nonatomic,strong)UIView              *noDataBaseView;
@end

@implementation QZFindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor redColor];
    [self.view addSubview:self.dataCollectionView];

}
#pragma mark -- Private Method
- (void)configCell:(QZFindCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataSource.count) {
        return;
    }
    if (self.dataSource.count <= indexPath.item) {//数组越界  下拉过程中造成数据混乱
        return;
    }
    FeedModel * feed = self.dataSource[indexPath.item];
    NSString *imgURL = feed.pic;
    if ([NSString isBlankString:imgURL]) {
        return;
    }
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    if ( !cachedImage ) {
        [self downloadImage:imgURL forIndexPath:indexPath];
        [cell.bgImgView setImage:nil];
    } else {
        [cell.bgImgView setImage:cachedImage];
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
                    [self.dataCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            });
        }
    }];
}
- (void)headerRefresh {
    if ([self.dataCollectionView.mj_footer isRefreshing]) {
        [self.listApiManager cancelAllRequest];
        [self.dataCollectionView.mj_footer endRefreshing];
    }
    if (self.dataCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.dataCollectionView.mj_footer setState:MJRefreshStateIdle];
    }
    self.lastAnchor = @"0";
    [self.listApiManager loadData];
    
}
- (void)footerRefresh {
    if ([self.dataCollectionView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.dataCollectionView.mj_footer endRefreshing];
        return;
    }
    if (self.dataSource.count) {
        FeedModel * feed = [self.dataSource lastObject];
        self.lastAnchor = feed.fid;
    }
    [self.dataCollectionView.mj_footer beginRefreshing];
    [self.listApiManager loadData];
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    return  @{@"anchor":self.lastAnchor};
}

#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if (manager == self.listApiManager) {
        NSLog(@"%@",manager.response);
        HomeListRefermer * refermer = [[HomeListRefermer alloc] init];        
        NSArray * callbackFeeds = [self.listApiManager fetchDataWithReformer:refermer];
        if ([self.dataCollectionView.mj_header isRefreshing]) {
            self.dataSource = [callbackFeeds mutableCopy];
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
        if ([self.dataCollectionView.mj_header isRefreshing]) {
            [self.dataCollectionView.mj_header endRefreshing];
        }
        if ([self.dataCollectionView.mj_footer isRefreshing]) {
            [self.dataCollectionView.mj_footer endRefreshing];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.dataSource.count>0) {
                if (_noDataBaseView) {
                    _noDataBaseView.hidden = YES;
                    self.dataCollectionView.mj_footer.hidden = NO;
                }
            } else {
                if (!_noDataBaseView) {
                    [self.dataCollectionView addSubview:self.noDataBaseView];
                }
                _noDataBaseView.hidden = NO;
                self.dataCollectionView.mj_footer.hidden = YES;
            }
            [self.dataCollectionView reloadData];
        });
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    if (manager == self.listApiManager) {
        if ([self.dataCollectionView.mj_header isRefreshing]) {
            [self.dataCollectionView.mj_header endRefreshing];
        }
        if ([self.dataCollectionView.mj_footer isRefreshing]) {
            [self.dataCollectionView.mj_footer endRefreshing];
        }
        [self showMessage:manager.errorMessage inView:self.view];
    }
}
#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QZFindCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    cell.feedModel = self.dataSource[indexPath.item];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    return cell;
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FeedDetailViewController * detailVC = [[FeedDetailViewController alloc] init];
    detailVC.feed_hash_name =self.dataSource[indexPath.row].feed_hash;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FeedModel * feed = self.dataSource[indexPath.item];
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
#pragma mark -- QZFindCollectionCellDelegate
- (void)qzFindCollectionCell:(QZFindCollectionCell *)cell didClieckedQZActionWithHashName:(NSString *)hashName {
    QZListVC *listVC = [[QZListVC alloc] init];
    listVC.hash_name = hashName;
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- getter && setter
- (UICollectionView *)dataCollectionView {
    
    if (!_dataCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10.0f;
//        CGFloat defaultHeight =SCREEN_WIDTH*9/16.0f;
//        layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH, defaultHeight);
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 7.0f);
        
        _dataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) collectionViewLayout:layout];
        [_dataCollectionView registerClass:[QZFindCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _dataCollectionView.delegate = self;
        _dataCollectionView.dataSource= self;
        _dataCollectionView.backgroundColor = [UIColor colorWithHexstring:@"f8f8f8"];
        _dataCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData ];
        _dataCollectionView.mj_footer = footer;
        [_dataCollectionView.mj_header beginRefreshing];
    }
    return _dataCollectionView;
}

- (HomeQuanZiApiManager *)listApiManager {
    if (!_listApiManager) {
        _listApiManager = [[HomeQuanZiApiManager alloc] init];
        _listApiManager.delegate = self;
        _listApiManager.paramsourceDelegate = self;
    }
    return _listApiManager;
}
- (UIView *)noDataBaseView {
    if (!_noDataBaseView) {
        _noDataBaseView = [[UIView alloc] initWithFrame:self.dataCollectionView.bounds];
        _noDataBaseView.hidden = YES;
        _noDataBaseView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, _noDataBaseView.height)];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorWithHexstring:@"666666"];
        titleLabel.text = @"圈子是一个私密交流场所，在这里没人知道你的真实身份。圈外人看不到你们说了什么，而圈内人可以毫无顾忌地说出真实想法，发表圈内八卦和小道消息。\n\n你还没有加入任何圈子，你可以等待邀请，也可以点击下方红色“+“创建自己的圈子。";
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_noDataBaseView addSubview:titleLabel];
    }
    return _noDataBaseView;
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
