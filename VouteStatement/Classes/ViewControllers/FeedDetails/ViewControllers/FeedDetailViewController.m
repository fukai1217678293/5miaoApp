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
#import "FeedDetailTableViewCell.h"
#import "VottingView.h"
#import "QZListVC.h"
#import "CommentFeedViewController.h"
#import "ReportViewController.h"
#import <UMMobClick/MobClick.h>
#import "ReportView.h"
#import "VTUserTagHelper.h"
@interface FeedDetailViewController ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource,UITableViewDelegate,UITableViewDataSource,FeedDetailTableViewCellDelegate,VottingViewDelegate>

@property (nonatomic,strong)UITableView     *detailTableView;
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
    [self.view addSubview:self.detailTableView];
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
    if ([self.detailTableView.mj_footer isRefreshing]) {
        [self.commentListApiManager cancelAllRequest];
        [self.detailTableView.mj_footer endRefreshing];
    }
    if (self.detailTableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.detailTableView.mj_footer setState:MJRefreshStateIdle];
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
    if ([self.detailTableView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.detailTableView.mj_footer endRefreshing];
        return;
    }
    if (self.commentsList.count) {
        self.page += 1;
    } else {
        self.page = 1;
    }
    [self.detailTableView.mj_footer beginRefreshing];
    [self.commentListApiManager loadData];

}
#pragma mark -- Private Method
- (void)toComment {
    WEAKSELF;
    CommentFeedViewController *commentVC = [[CommentFeedViewController alloc] init];
    commentVC.feed_hash = self.feed_hash_name;
    commentVC.publishCommentHandle = ^(){
        [weakSelf.detailTableView.mj_header beginRefreshing];
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
- (void)configCell:(FeedDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 1) {
        return;
    }
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
        [_detailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
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
                [self.detailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.feedDetailApiManager) {
        self.feedDetailHUD = [self showHUDLoadingWithMessage:@"" inView:self.view];
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
        [self hiddenHUD:self.feedDetailHUD];
        self.feedDetailModel = [manager fetchDataWithReformer:[FeedDetailReformer new]];
        [self updateSubViews];
        [self.detailTableView reloadData];
        if (self.loadedShowShareAction) {
            self.loadedShowShareAction = NO;
            [self shareAction:nil];
        }
    }
    else if ([manager isKindOfClass:[CommentListApiManager class]]) {
        NSArray *resultArray = [manager fetchDataWithReformer:[FeedDetailReformer new]];
        if ([self.detailTableView.mj_header isRefreshing]) {
            self.commentsList = [resultArray mutableCopy];
        }
        else {
            if (!resultArray.count || !resultArray) {
                [self.detailTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            else {
                [self.commentsList addObjectsFromArray:resultArray];
            }
        }
        if ([self.detailTableView.mj_header isRefreshing]) {
            [self.detailTableView.mj_header endRefreshing];
        }
        if ([self.detailTableView.mj_footer isRefreshing]) {
            [self.detailTableView.mj_footer endRefreshing];
        }
        [_detailTableView reloadData];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    [self hiddenHUD:self.feedDetailHUD];
    if (manager == self.feedDetailApiManager) {
        [self showMessage:manager.errorMessage inView:self.view];
    }
    else if (manager == self.commentListApiManager){
        if ([self.detailTableView.mj_header isRefreshing]) {
            [self.detailTableView.mj_header endRefreshing];
        }
        if ([self.detailTableView.mj_footer isRefreshing]) {
            [self.detailTableView.mj_footer endRefreshing];
        }
    }
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.feedDetailModel) {
        if (!self.feedDetailModel.voted) {//是否已投票 未投票用户不允许查看更多评论
            if (self.feedDetailModel.haveContent) {//有内容
                return 3;
            } else {//无内容
                return 2;
            }
        }
        if (self.feedDetailModel.haveContent) {
            return 4;
        } else {
            return 3;
        }
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.feedDetailModel) {
        if (self.feedDetailModel.voted) {
            if (self.feedDetailModel.haveContent) {
                if (section == 3) {
                    return self.commentsList.count +1;
                }
            } else {
                if (section == 2) {
                    return self.commentsList.count +1;
                }
            }
        }
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId;
    if (indexPath.section == 0) {
        cellId = FeedDetailTableViewTitleCellIdentifier;
    }else if (indexPath.section == 1) {
        if (self.feedDetailModel.haveContent) {
            cellId =FeedDetailTableViewFeedContentCellIdentifier;
        } else {
            cellId =FeedDetailTableViewPointVSCellIdentifier;
        }
    }else if (indexPath.section == 2) {
        if (self.feedDetailModel.voted) {
            if (self.feedDetailModel.haveContent) {//有内容
                cellId =FeedDetailTableViewPointVSCellIdentifier;
            } else {
                if (indexPath.row == 0) {
                    cellId = FeedDetailTableViewCommentHeaderCellIdentifier;
                    
                } else {
                    cellId = FeedDetailTableViewCommentCellIdentifier;
                }
            }
        } else {
            if (self.feedDetailModel.haveContent) {
                cellId =FeedDetailTableViewPointVSCellIdentifier;
            } else {//无内容 未投票 只有两个section
                return nil;
            }
        }
    }else if (indexPath.section == 3){
        if (self.feedDetailModel.voted) {
            if (self.feedDetailModel.haveContent) {//有内容
                if (indexPath.row == 0) {
                    cellId = FeedDetailTableViewCommentHeaderCellIdentifier;
                    
                } else {
                    cellId = FeedDetailTableViewCommentCellIdentifier;
                }
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    }
    FeedDetailTableViewCell *cell = [FeedDetailTableViewCell loadCellWithTableView:tableView reuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (self.feedDetailModel.voted) {
        if (self.feedDetailModel.haveContent) {
            if (indexPath.section == 3 && indexPath.row != 0) {
                cell.comment = self.commentsList[indexPath.row-1];
            }
        } else {
            if (indexPath.section == 2 && indexPath.row != 0) {
                cell.comment = self.commentsList[indexPath.row-1];
            }
        }
    }
    WEAKSELF;
    [self configCell:cell atIndexPath:indexPath];
    [cell congfigContentView:self.feedDetailModel];
    [cell setJoinCircleHandle:^(UIButton *sender){
        if (sender.selected) {
            [weakSelf.exitCircleApiManager loadData];
            weakSelf.feedDetailModel.joined = NO;
        }else {
            [weakSelf.joinCircleApiManager loadData];
            weakSelf.feedDetailModel.joined = YES;
        }
        [[VTUserTagHelper sharedHelper] startBindNewTags];
        sender.selected = !sender.selected;
    }];
    [cell setPushToCircleHomePage:^(UIButton *sender){
        QZListVC *circleHomeListVC = [[QZListVC alloc] init];
        circleHomeListVC.hash_name = weakSelf.feedDetailModel.circle_hash;
        [weakSelf.navigationController pushViewController:circleHomeListVC animated:YES];
    }];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!self.feedDetailModel) {
        return 0;
    }
    if (section == 0) {
        if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 40;
        }
        return 10;
    }
    else if (section == 1) {
        if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 0;
        }
        if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            return 40;
        }
        if (self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 10;
        }
        if (self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            return 10;
        }
        return 0;
    }
    else if (section == 2) {
        if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 0;
        }
        if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            return 0;
        }
        if (self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 0;
        }
        if (self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            return 10;
        }
        return 0;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.feedDetailModel) {
        return 0;
    }
    if (indexPath.section == 0) {
        if ([NSString isBlankString:self.feedDetailModel.circle_name]) {
            return 80;
        }
        return 135;
    }
    else if (indexPath.section == 1) {
        if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 70;
        }
        if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            if ([NSString isBlankString:self.feedDetailModel.pic]) {
                return self.feedDetailModel.contentHeight+20;
            } else {
                return self.feedDetailModel.imageHeigth + self.feedDetailModel.contentHeight+30;
            }
//            return self.feedDetailModel.imageHeigth + self.feedDetailModel.contentHeight+30;
        }
        if (self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 70;
        }
        if (self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            if ([NSString isBlankString:self.feedDetailModel.pic]) {
                return self.feedDetailModel.contentHeight+20;
            } else {
                return self.feedDetailModel.imageHeigth + self.feedDetailModel.contentHeight+30;
            }
        }
        return 0.0f;
    }
    else if (indexPath.section == 2) {
        if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 0;
        }
        if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            return 70;
        }
        if (self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            if (indexPath.row == 0) return 40;
            return self.commentsList[indexPath.row-1].contentHeight +60;
        }
        if (self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            return 70;
        }
        return 0;
    }
    else if (indexPath.section == 3) {
        if (!self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 0;
        }
        if (!self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            return 0;
        }
        if (self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
            return 0;
        }
        if (self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
            if (indexPath.row == 0) return 40;
            return self.commentsList[indexPath.row-1].contentHeight +60;
        }
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BOOL ret = NO;
    if (section == 0 && !self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
        ret = YES;
    }
    if (section ==1 && !self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
        ret = YES;
    }
    else if (section == 2 && self.feedDetailModel.voted && !self.feedDetailModel.haveContent) {
        ret = YES;
    }
    else if (section == 3 && self.feedDetailModel.voted && self.feedDetailModel.haveContent) {
        ret = YES;
    }
    if (ret) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        bgView.backgroundColor = [UIColor colorWithHexstring:@"f5f5f5"];
        UIView *singleline = [[UIView alloc] initWithFrame:CGRectMake(10, 39.2/2.0f, SCREEN_WIDTH-20, 0.8)];
        singleline.backgroundColor = [UIColor colorWithHexstring:@"e1e1e1"];
        [bgView addSubview:singleline];
        NSString *countString = [NSString stringWithFormat:@"已有%d票",[self.feedDetailModel.all_vote intValue]];
        CGFloat rightCountWidth = [countString boundingRectWithSize:CGSizeMake(MAXFLOAT,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.width;
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-rightCountWidth-10)/2.0f, 0, rightCountWidth+10, 40)];
        countLabel.text = countString;
        countLabel.backgroundColor = [UIColor colorWithHexstring:@"f5f5f5"];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.font = [UIFont systemFontOfSize:13];
        countLabel.textColor = [UIColor colorWithHexstring:@"333333"];
        [bgView addSubview:countLabel];
        return bgView;
    }
    return nil;
}
#pragma mark -- FeedDetailTableViewCellDelegate
- (void)feedDetailTableViewCell:(FeedDetailTableViewCell *)cell commentView:(CommentView *)commentView didClickedDianZanAction:(UIButton *)sender commentModel:(CommentModel *)comment {
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
    [self.detailTableView.mj_header beginRefreshing];
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
- (UITableView *)detailTableView {
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStylePlain];
        _detailTableView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        _detailTableView.delegate   = self;
        _detailTableView.dataSource = self;
        _detailTableView.tableFooterView = [UIView new];
        _detailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData ];
        _detailTableView.mj_footer = footer;
        [_detailTableView.mj_header beginRefreshing];
    }
    return _detailTableView;
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


@end
