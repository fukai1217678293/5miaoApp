//
//  FeedDetailViewController.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/29.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedDetailViewController.h"
#import <UShareUI/UShareUI.h>
#import "FeedDetailReformer.h"
#import "FeedDetailApiManager.h"
#import "UpForCommentApiManager.h"
#import "CommentListApiManager.h"
#import "JoinQZApiManager.h"
#import "ExitCircleApiManager.h"
#import "FeedDetailModel.h"
#import "RegistViewController.h"
#import "VottingView.h"
#import "QZListVC.h"
#import "CommentFeedViewController.h"
#import "ReportViewController.h"
#import <UMMobClick/MobClick.h>
#import "ReportView.h"
#import "VTUserTagHelper.h"
#import "FeedDetailCollectionCell.h"
@interface FeedDetailViewController ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource,FeedDetailTableViewCellDelegate,VottingViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIScrollViewDelegate>

//@property (nonatomic,strong)UITableView     *detailTableView;
@property (nonatomic,strong)UICollectionView        *detailCollectionView;
@property (nonatomic,strong)FeedDetailApiManager    *feedDetailApiManager;
@property (nonatomic,strong)CommentListApiManager   *commentListApiManager;
@property (nonatomic,strong)JoinQZApiManager        *joinCircleApiManager;
@property (nonatomic,strong)ExitCircleApiManager    *exitCircleApiManager;
@property (nonatomic,strong)UIBarButtonItem *shareItem;
@property (nonatomic,strong)UIBarButtonItem *reportedItem;
@property (nonatomic,strong)MBProgressHUD   *feedDetailHUD;
@property (nonatomic,strong)FeedDetailModel *feedDetailModel;
@property (nonatomic,strong)NSMutableArray <CommentModel *> *commentsList;
@property (nonatomic,strong)UIView          *footerView;
@property (nonatomic,strong)UIView          *sectionFooterView;
@property (nonatomic,assign)int              page;

@end

@implementation FeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"view_feed"];
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"话题";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.navigationItem.rightBarButtonItems = @[self.reportedItem,self.shareItem];
//    [self.view addSubview:self.detailTableView];
    [self.view addSubview:self.detailCollectionView];
    [self.feedDetailApiManager loadData];
    self.view.backgroundColor =UIRGBColor(242, 242, 242, 1.0f);
}
#pragma mark -- Event Response
- (void)shareAction:(UIButton *)sender {
    NSString *title =[NSString isBlankString:self.feedDetailModel.circle_hash] ? @"请选择分享平台":@"分享,邀请好友加入这个圈子";
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = YES;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = title;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewFont = [UIFont systemFontOfSize:14];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine)]];
    WEAKSELF;
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
            [weakSelf.feedDetailApiManager loadData];
            [weakSelf jubaoActionClicked];
        };
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    else {
        ReportView *reportView = [[ReportView alloc] initWithReportType:NSReportTypeWithQuanZi];
        WEAKSELF;
        reportView.actionClickedHandle = ^(NSInteger index) {
            ReportViewController *reportVC = [[ReportViewController alloc] init];
            reportVC.feed_hash = weakSelf.feed_hash_name;
            [weakSelf.navigationController pushViewController:reportVC animated:YES];
        };
        [reportView showInView:self.navigationController.view];
    }
}
- (void)voteClicked:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"写评论"]) {
        [self toComment];
    }
    else {
        [self showVoteView];
    }
}
- (void)headerRefresh {
    if ([self.detailCollectionView.mj_footer isRefreshing]) {
        [self.commentListApiManager cancelAllRequest];
        [self.detailCollectionView.mj_footer endRefreshing];
    }
    if (self.detailCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.detailCollectionView.mj_footer setState:MJRefreshStateIdle];
    }
    if (!_joinCircleApiManager) {
        [_joinCircleApiManager cancelAllRequest];
    }
    if (!_exitCircleApiManager) {
        [_exitCircleApiManager cancelAllRequest];
    }
    self.page = 1;
    [self.feedDetailApiManager loadData];
    [self.commentListApiManager loadData];
    
}
- (void)footerRefresh {
    if ([self.detailCollectionView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.detailCollectionView.mj_footer endRefreshing];
        return;
    }
    if (self.commentsList.count) {
        self.page += 1;
    } else {
        self.page = 1;
    }
    [self.detailCollectionView.mj_footer beginRefreshing];
    [self.commentListApiManager loadData];

}
#pragma mark -- Private Method
- (void)toComment {
    WEAKSELF;
    CommentFeedViewController *commentVC = [[CommentFeedViewController alloc] init];
    commentVC.feed_hash = self.feed_hash_name;
    commentVC.publishCommentHandle = ^(){
        [weakSelf.detailCollectionView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:commentVC animated:YES];
}
- (void)showVoteView {
    if (![VTAppContext shareInstance].isOnline) {//未登录
        RegistViewController *registVC = [[RegistViewController alloc] init];
        UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:registVC];
        WEAKSELF;
        registVC.completionhandle = ^ {
            [weakSelf.feedDetailApiManager loadData];
        };
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    else {
        VottingView * voteView = [[VottingView alloc] initWithDataModel:self.feedDetailModel];
        voteView.presentViewController = self;
        voteView.feed_hash = self.feed_hash_name;
        voteView.delegate = self;
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [voteView showInView:window];
    }
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL = self.feedDetailModel.share_pic;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.feedDetailModel.share_title descr:self.feedDetailModel.share_desc thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.feedDetailModel.share_link;
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
- (void)configCell:(FeedDetailCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *imgURL = self.feedDetailModel.pic;
    if ([NSString isBlankString:imgURL]) {
        return;
    }
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    if ( !cachedImage ) {
        [self downloadImage:imgURL forIndexPath:indexPath];
        [cell.contentImageView setImage:nil];
    } else {
        [cell.contentImageView setImage:cachedImage];
        self.feedDetailModel.imageHeigth = (CGFloat)(SCREEN_WIDTH - 20)*cachedImage.size.height/(CGFloat)cachedImage.size.width;
        [_detailCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}
- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    WEAKSELF;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // do nothing
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (!error) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.detailCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
        }
    }];
}
- (void)updateSubViews{
    if (!_footerView) {
        [self.view addSubview:self.footerView];
    }
    UIButton *bottomButton = [_footerView viewWithTag:2001];
    if (self.feedDetailModel.voted) {
        [bottomButton setTitle:@"写评论" forState:UIControlStateNormal];
    } else {
        [bottomButton setTitle:@"立即投票解锁更多精彩内容" forState:UIControlStateNormal];
    }
}
- (NSString *)getCellIdentiferWithIndexPath:(NSIndexPath *)indexPath {
    if (!self.feedDetailModel) {
        return nil;
    }
    if (self.feedDetailModel) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return FeedDetailTableViewTitleCellIdentifier;
            } else if (indexPath.row == 1) {
                if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
                    return FeedDetailTableViewVotedCountHeaderCellIdentifier;
                }
                if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                    return FeedDetailTableViewFeedContentCellIdentifier;
                }
                if (self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
                    return FeedDetailTableViewPointVSCellIdentifier;
                }
                if (self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                    return FeedDetailTableViewFeedContentCellIdentifier;
                }
            } else if (indexPath.row == 2) {
                if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
                    return FeedDetailTableViewPointVSCellIdentifier;
                }
                if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                    return FeedDetailTableViewVotedCountHeaderCellIdentifier;
                }
                if (self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
                    return nil;
                }
                if (self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                    return FeedDetailTableViewPointVSCellIdentifier;
                }
            } else if (indexPath.row == 3) {
                if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                    return FeedDetailTableViewPointVSCellIdentifier;
                }
                return nil;
            }
        }
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return FeedDetailTableViewCommentHeaderCellIdentifier;
            } else {
                return FeedDetailTableViewCommentCellIdentifier;
            }
        }
    }
    return nil;
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.feedDetailApiManager) {
        if (!self.feedDetailHUD) {
            self.feedDetailHUD = [self showHUDLoadingWithMessage:@"" inView:self.view];
        }
    }
    else if ([manager isKindOfClass:[UpForCommentApiManager class]]) {
        //        return @{@"side":self.feedDetailModel.side};
    }
    else if ([manager isKindOfClass:[CommentListApiManager class]]) {
        return @{@"page":@(_page)};
    } else if ([manager isKindOfClass:[JoinQZApiManager class]]) {
        return @{@"hash":self.feedDetailModel.circle_hash};
    }
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if (manager == self.feedDetailApiManager) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenHUD:self.feedDetailHUD];
            self.feedDetailHUD = nil;
        });
        self.feedDetailModel = [manager fetchDataWithReformer:[FeedDetailReformer new]];
        [self updateSubViews];
        [UIView performWithoutAnimation:^{
            [self.detailCollectionView reloadData];
        }];
        if (self.loadedShowShareAction) {
            self.loadedShowShareAction = NO;
            [self shareAction:nil];
        }
    }
    else if ([manager isKindOfClass:[CommentListApiManager class]]) {
        NSArray *resultArray = [manager fetchDataWithReformer:[FeedDetailReformer new]];
        if ([self.detailCollectionView.mj_header isRefreshing]) {
            self.commentsList = [resultArray mutableCopy];
        }
        else {
            if (!resultArray.count || !resultArray) {
                [self.detailCollectionView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            else {
                [self.commentsList addObjectsFromArray:resultArray];
            }
        }
        if ([self.detailCollectionView.mj_header isRefreshing]) {
            [self.detailCollectionView.mj_header endRefreshing];
        }
        if ([self.detailCollectionView.mj_footer isRefreshing]) {
            [self.detailCollectionView.mj_footer endRefreshing];
        }
        if (self.commentsList.count) {
            [UIView performWithoutAnimation:^{
                [_detailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            }];
        }
    }
    else if (manager == self.exitCircleApiManager || manager == self.joinCircleApiManager) {
        [[VTUserTagHelper sharedHelper] startBindNewTags];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    [self hiddenHUD:self.feedDetailHUD];
    self.feedDetailHUD = nil;
    if (manager == self.feedDetailApiManager) {
        [self showMessage:manager.errorMessage inView:self.view];
    }
    else if (manager == self.commentListApiManager){
        if ([self.detailCollectionView.mj_header isRefreshing]) {
            [self.detailCollectionView.mj_header endRefreshing];
        }
        if ([self.detailCollectionView.mj_footer isRefreshing]) {
            [self.detailCollectionView.mj_footer endRefreshing];
        }
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(10, 0, 0, 0);//分别为上、左、下、右
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 0;
    }
    return 10;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!self.feedDetailModel) {
        return 0;
    }
    if (self.feedDetailModel.voted) {
        return 2;
    }
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.feedDetailModel) {
        return 0;
    }
    if (section == 0) {
        if (self.feedDetailModel.voted) {
            if (self.feedDetailModel.haveContent) {
                return 3;
            } else {
                return 2;
            }
        } else {
            if (self.feedDetailModel.haveContent) {
                return 4;
            } else {
                return 3;
            }
        }
    }
    return self.commentsList.count + 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.feedDetailModel) {
        return CGSizeMake(SCREEN_WIDTH, 0);
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([NSString isBlankString:self.feedDetailModel.circle_name]) {
                return CGSizeMake(SCREEN_WIDTH, 80);
            }
            return CGSizeMake(SCREEN_WIDTH, 135);
        } else if (indexPath.row == 1) {
            if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
                return CGSizeMake(SCREEN_WIDTH, 40);
            }
            if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                if ([NSString isBlankString:self.feedDetailModel.pic]) {
                    return CGSizeMake(SCREEN_WIDTH,self.feedDetailModel.contentHeight+20);
                } else {
                    return CGSizeMake(SCREEN_WIDTH,self.feedDetailModel.imageHeigth + self.feedDetailModel.contentHeight+30);
                }
            }
            if (self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
                return CGSizeMake(SCREEN_WIDTH, 70);
            }
            if (self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                if ([NSString isBlankString:self.feedDetailModel.pic]) {
                    return CGSizeMake(SCREEN_WIDTH,self.feedDetailModel.contentHeight+20);
                } else {
                    return CGSizeMake(SCREEN_WIDTH,self.feedDetailModel.imageHeigth + self.feedDetailModel.contentHeight+30);
                }
            }
        } else if (indexPath.row == 2) {
            if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
                return CGSizeMake(SCREEN_WIDTH, 70);
            }
            if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                return CGSizeMake(SCREEN_WIDTH, 40);
            }
            if (self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
                return CGSizeMake(SCREEN_WIDTH, 0);
            }
            if (self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                return CGSizeMake(SCREEN_WIDTH, 70);
            }
        } else if (indexPath.row == 3) {
            if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
                return CGSizeMake(SCREEN_WIDTH, 70);
            }
            return CGSizeMake(SCREEN_WIDTH, 0);
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREEN_WIDTH, 40);
        } else {
            return CGSizeMake(SCREEN_WIDTH, self.commentsList[indexPath.row-1].contentHeight +60);
        }
        return CGSizeMake(SCREEN_WIDTH, 0);
    }
    return CGSizeMake(SCREEN_WIDTH, 0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [self getCellIdentiferWithIndexPath:indexPath];
    FeedDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.delegate = self;    
    if ([cellId isEqualToString:FeedDetailTableViewFeedContentCellIdentifier]) {
        [self configCell:cell atIndexPath:indexPath];
    }
    WEAKSELF;
    [cell congfigContentView:self.feedDetailModel];
    if (indexPath.section == 1 && indexPath.row != 0) {
        if (self.commentsList.count) {
            cell.comment = self.commentsList[indexPath.row-1];
        }
    }
    [cell setJoinCircleHandle:^(UIButton *sender){
        if (sender.selected) {
            [weakSelf.exitCircleApiManager loadData];
            weakSelf.feedDetailModel.joined = NO;
        }else {
            [weakSelf.joinCircleApiManager loadData];
            weakSelf.feedDetailModel.joined = YES;
        }
        sender.selected = !sender.selected;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[VTUserTagHelper sharedHelper] startBindNewTags];
        });
    }];
    [cell setPushToCircleHomePage:^(UIButton *sender){
        QZListVC *circleHomeListVC = [[QZListVC alloc] init];
        circleHomeListVC.hash_name = weakSelf.feedDetailModel.circle_hash;
        [weakSelf.navigationController pushViewController:circleHomeListVC animated:YES];
    }];
    
    return cell;
}

#pragma mark -- FeedDetailTableViewCellDelegate
- (void)feedDetailTableViewCell:(FeedDetailCollectionCell *)cell commentView:(CommentView *)commentView didClickedDianZanAction:(UIButton *)sender commentModel:(CommentModel *)comment {
    if (![VTAppContext shareInstance].isOnline) {//未登录
        RegistViewController *registVC = [[RegistViewController alloc] init];
        UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:registVC];
        WEAKSELF;
        registVC.completionhandle = ^ {
            [weakSelf.feedDetailApiManager loadData];
        };
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    else {
        if (sender.selected == YES) {
            [self showMessage:@"您已经为Ta点过赞啦~~" inView:self.view];
            return;
        }
        UpForCommentApiManager *apiManager = [[UpForCommentApiManager alloc] initWithCid:comment.cid];
        apiManager.delegate = self;
        apiManager.paramsourceDelegate = self;
        sender.selected = YES;
        comment.up = [NSString stringWithFormat:@"%d",[comment.up intValue]+1];
        [sender setTitle:[NSString stringWithFormat:@"%@",comment.up] forState:UIControlStateNormal];
        comment.uped = @"1";
        [apiManager loadData];
    }
}
#pragma mark -- VottingViewDelegate
- (void)vottingView:(VottingView *)voteView didVotedInSide:(int)side posvotes:(int)posVote negvotes:(int)negvote {
    [self.detailCollectionView.mj_header beginRefreshing];
}
- (void)vottingView:(VottingView *)voteView didClickedShareItem:(NSUInteger)sharePlatformOption {
    UMSocialPlatformType platformType;
    if (sharePlatformOption == 0) {
        platformType = UMSocialPlatformType_QQ;
    }
    else if (sharePlatformOption == 1) {
        platformType = UMSocialPlatformType_WechatSession;
    }
    else {
        platformType = UMSocialPlatformType_WechatTimeLine;
    }
    [self shareWebPageToPlatformType:platformType];
}
#pragma mark -- getter
- (FeedDetailApiManager *)feedDetailApiManager {
    if (!_feedDetailApiManager) {
        _feedDetailApiManager = [[FeedDetailApiManager alloc] initWithHash:self.feed_hash_name];
        _feedDetailApiManager.delegate = self;
        _feedDetailApiManager.paramsourceDelegate = self;
    }
    return _feedDetailApiManager;
}
- (CommentListApiManager *)commentListApiManager {
    if (!_commentListApiManager) {
        _commentListApiManager = [[CommentListApiManager alloc] initWithHash:self.feed_hash_name];
        _commentListApiManager.delegate = self;
        _commentListApiManager.paramsourceDelegate = self;
    }
    return _commentListApiManager;
}
- (JoinQZApiManager *)joinCircleApiManager {
    if (!_joinCircleApiManager) {
        _joinCircleApiManager = [[JoinQZApiManager alloc] init];
        _joinCircleApiManager.delegate = self;
        _joinCircleApiManager.paramsourceDelegate = self;
    }
    return _joinCircleApiManager;
}
- (ExitCircleApiManager *)exitCircleApiManager {
    if (!_exitCircleApiManager) {
        _exitCircleApiManager = [[ExitCircleApiManager alloc] initWithCircleHash:self.feedDetailModel.circle_hash];
        _exitCircleApiManager.delegate = self;
        _exitCircleApiManager.paramsourceDelegate = self;
    }
    return _exitCircleApiManager;
}
- (UIBarButtonItem *)shareItem {
    if (!_shareItem) {
        UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
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

- (NSMutableArray *)commentsList {
    if (!_commentsList) {
        _commentsList = [NSMutableArray arrayWithCapacity:0];
    }
    return _commentsList;
}
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-65, SCREEN_WIDTH, 65)];
        _footerView.backgroundColor = [UIColor clearColor];
        UIButton *voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        voteButton.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 45);
        voteButton.backgroundColor = UIRGBColor(245, 45, 84, 1.0f);
        [voteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        voteButton.titleLabel.font = [UIFont systemFontOfSize:19];
        voteButton.layer.cornerRadius = 5.0f;
        voteButton.layer.masksToBounds = YES;
        [voteButton addTarget:self action:@selector(voteClicked:) forControlEvents:UIControlEventTouchUpInside];
        voteButton.tag = 2001;
        [_footerView addSubview:voteButton];
    }
    return _footerView;
}
- (UICollectionView *)detailCollectionView {
    
    if (!_detailCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10.0f;
        //        CGFloat defaultHeight =SCREEN_WIDTH*9/16.0f;
        
//        layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH, 70);
//        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 7.0f);
        layout.minimumInteritemSpacing = 10.0f;
        _detailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-65) collectionViewLayout:layout];
        [_detailCollectionView registerClass:[FeedDetailCollectionCell class] forCellWithReuseIdentifier:FeedDetailTableViewTitleCellIdentifier];
        [_detailCollectionView registerClass:[FeedDetailCollectionCell class] forCellWithReuseIdentifier:FeedDetailTableViewFeedContentCellIdentifier];
        [_detailCollectionView registerClass:[FeedDetailCollectionCell class] forCellWithReuseIdentifier:FeedDetailTableViewPointVSCellIdentifier];
        [_detailCollectionView registerClass:[FeedDetailCollectionCell class] forCellWithReuseIdentifier:FeedDetailTableViewCommentHeaderCellIdentifier];
        [_detailCollectionView registerClass:[FeedDetailCollectionCell class] forCellWithReuseIdentifier:FeedDetailTableViewCommentCellIdentifier];
        [_detailCollectionView registerClass:[FeedDetailCollectionCell class] forCellWithReuseIdentifier:FeedDetailTableViewVotedCountHeaderCellIdentifier];
        _detailCollectionView.delegate = self;
        _detailCollectionView.dataSource= self;
        _detailCollectionView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        _detailCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData ];
        _detailCollectionView.mj_footer = footer;
        [_detailCollectionView.mj_header beginRefreshing];
    }
    return _detailCollectionView;
}

@end
