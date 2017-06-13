//
//  QZListVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/22.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "QZListVC.h"
#import "QZListApiManager.h"
#import "QZInfoApiManager.h"
#import "JoinQZApiManager.h"
#import "QZReformer.h"
#import "FeedModel.h"
#import "HomeListRefermer.h"
#import "QZInformationModel.h"
#import "ReportVC.h"
#import "RegistViewController.h"
#import "ReportView.h"
#import "QZHomeListCollectionCell.h"
#import <UShareUI/UShareUI.h>
#import "ExitCircleApiManager.h"
#import "FeedDetailViewController.h"
#import <UMMobClick/MobClick.h>
#import "VTUserTagHelper.h"

@interface QZListVC ()<VTAPIManagerParamSource,VTAPIManagerCallBackDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,QZInformationCollectionCellDelegate>

@property (nonatomic,strong)UIBarButtonItem *shareItem;
@property (nonatomic,strong)UIBarButtonItem *reportedItem;
@property (nonatomic,strong)QZInfoApiManager *infoApiManager;
@property (nonatomic,strong)QZListApiManager *listApiManager;
@property (nonatomic,strong)UICollectionView *dataCollectionView;
@property (nonatomic,strong)NSMutableArray <FeedModel *>*dataSource;
@property (nonatomic,strong)QZInformationModel*qzInformationModel;
@property (nonatomic,strong)JoinQZApiManager  *joinQZApiManager;
@property (nonatomic,strong)ExitCircleApiManager    *exitQZApiManager;
@property (nonatomic,strong)NSString            *lastAnchor;

@end

@implementation QZListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"view_circle"];
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"圈子";
    self.navigationItem.rightBarButtonItems = @[self.shareItem];
    [self.view addSubview:self.dataCollectionView];
    [self.infoApiManager loadData];
}
#pragma mark -- Event Response 
- (void)shareAction:(UIButton *)sender {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine)]];
    WEAKSELF;

    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = YES;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"分享,邀请好友加入这个圈子";
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewFont = [UIFont systemFontOfSize:14];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [weakSelf shareWebPageToPlatformType:platformType];
    }];
}
- (void)jubaoActionClicked {
    if (![VTAppContext shareInstance].isOnline) {//未登录
        RegistViewController *registVC = [[RegistViewController alloc] init];
        UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:registVC];
        WEAKSELF;
        registVC.completionhandle = ^ {
            [weakSelf.infoApiManager loadData];
            [weakSelf jubaoActionClicked];
        };
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    else {
        ReportView *reportView = [[ReportView alloc] initWithReportType:NSReportTypeWithQuanZi];
        WEAKSELF;
        reportView.actionClickedHandle = ^(NSInteger index) {
            ReportVC *reportVC = [[ReportVC alloc] init];
            [weakSelf.navigationController pushViewController:reportVC animated:YES];
        };
        [reportView showInView:self.navigationController.view];
    }
}
#pragma mark -- Private Method
- (void)configCell:(QZHomeListCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    FeedModel * feed = self.dataSource[indexPath.item-1];
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
                if (self.dataSource.count > (indexPath.item-1)) {//
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
    if (!self.qzInformationModel) {
        [self.infoApiManager loadData];
    }
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
    if (manager == self.listApiManager) {
        return  @{@"anchor":self.lastAnchor};
    } else if (manager == self.joinQZApiManager) {
        return @{@"hash":self.hash_name};
    }
    return @{};
}

#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if (manager == self.listApiManager) {
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
        [self.dataCollectionView reloadData];
    }
    else if (manager == self.infoApiManager) {
        
        QZReformer *reformer = [[QZReformer alloc] init];
        self.qzInformationModel = [manager fetchDataWithReformer:reformer];
        [self.dataCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    }
    else if (manager == self.exitQZApiManager || manager == self.joinQZApiManager) {
        [[VTUserTagHelper sharedHelper] startBindNewTags];
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
    return self.dataSource.count+1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        QZInformationCollectionCell *infoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"infoCell" forIndexPath:indexPath];
        infoCell.contentView.backgroundColor = [UIColor whiteColor];
        infoCell.informationModel = self.qzInformationModel;
        infoCell.delegate = self;
        return infoCell;
    } else {
        QZHomeListCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        [self configCell:cell atIndexPath:indexPath];
        cell.feedModel = self.dataSource[indexPath.item-1];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        return;
    }
    FeedDetailViewController *detailVC ;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[FeedDetailViewController class]]) {
            FeedDetailViewController * tempVC =(FeedDetailViewController *) viewController;
            if ([tempVC.feed_hash_name isEqualToString:self.dataSource[indexPath.item-1].feed_hash]) {
                detailVC = tempVC;
                break;
            }
            continue;
        }
    }
    if (!detailVC) {
        detailVC = [[FeedDetailViewController alloc] init];
        detailVC.feed_hash_name = self.dataSource[indexPath.item-1].feed_hash;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        [self.navigationController popToViewController:detailVC animated:YES];
    }
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataSource.count) {
        return CGSizeZero;
    }
    if (indexPath.row == 0) {
        return CGSizeMake(SCREEN_WIDTH, 70);
    }
    FeedModel * feed = self.dataSource[indexPath.item-1];
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
#pragma mark -- QZInformationCollectionCellDelegate
- (void)qzInformationCollectionCell:(QZInformationCollectionCell *)cell didClickedJoinQZButton:(UIButton *)button {
    if (self.qzInformationModel.joined) {
        [self.exitQZApiManager loadData];
        self.qzInformationModel.joined = NO;
    } else {
        [self.joinQZApiManager loadData];
        self.qzInformationModel.joined = YES;
    }
    [[VTUserTagHelper sharedHelper] startBindNewTags];
    [self.dataCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
}
#pragma mark -- Private Method
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL = self.qzInformationModel.share_pic;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.qzInformationModel.share_title descr:self.qzInformationModel.share_desc thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.qzInformationModel.share_link;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark -- getter
- (UICollectionView *)dataCollectionView {
    if (!_dataCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10.0f;
        CGFloat defaultHeight =SCREEN_WIDTH*9/16.0f;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, defaultHeight);
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 7.0f);
        
        _dataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        [_dataCollectionView registerClass:[QZHomeListCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        [_dataCollectionView registerClass:[QZInformationCollectionCell class] forCellWithReuseIdentifier:@"infoCell"];
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

- (UIBarButtonItem *)shareItem {
    if (!_shareItem) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 28, 28);
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"icon_fenxiang.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _shareItem;
}
- (UIBarButtonItem *)reportedItem {
    
    if (!_reportedItem) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 28, 28);
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"icon_jubao.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(jubaoActionClicked) forControlEvents:UIControlEventTouchUpInside];
        _reportedItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _reportedItem;
}
- (QZListApiManager *)listApiManager {
    if (!_listApiManager) {
        _listApiManager = [[QZListApiManager alloc] initWithHash:self.hash_name];
        _listApiManager.delegate = self;
        _listApiManager.paramsourceDelegate = self;
    }
    return _listApiManager;
}
- (QZInfoApiManager *)infoApiManager {
    if (!_infoApiManager) {
        _infoApiManager = [[QZInfoApiManager alloc] initWithHash:self.hash_name];
        _infoApiManager.delegate = self;
        _infoApiManager.paramsourceDelegate = self;
    }
    return _infoApiManager;
}
- (JoinQZApiManager *)joinQZApiManager {
    if (!_joinQZApiManager) {
        _joinQZApiManager = [[JoinQZApiManager alloc] init];
        _joinQZApiManager.delegate = self;
        _joinQZApiManager.paramsourceDelegate = self;
    }
    return _joinQZApiManager;
}
- (ExitCircleApiManager *)exitQZApiManager {
    if (!_exitQZApiManager) {
        _exitQZApiManager = [[ExitCircleApiManager alloc] initWithCircleHash:self.hash_name];
        _exitQZApiManager.delegate = self;
        _exitQZApiManager.paramsourceDelegate = self;
    }
    return _exitQZApiManager;
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
