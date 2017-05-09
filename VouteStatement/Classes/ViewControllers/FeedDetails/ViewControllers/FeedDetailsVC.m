//
//  FeedDetailsVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/24.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "FeedDetailsVC.h"
#import "FeedDetailTableViewCell.h"
#import "FeedDetailApiManager.h"
#import "FeedDetailReformer.h"
#import "FeedDetailModel.h"
#import "VouteHeaderView.h"
#import "VottingView.h"
#import "MoreCommentVC.h"
#import "AddCommentVC.h"
#import "AddCollectionApiManager.h"
#import "CancelCollectionApiManager.h"
#import "VoteContentView.h"
#import "UpForCommentApiManager.h"
#import "VoteSliderView.h"
#import "VoteSliderView.h"
#import "OtherUserCenterVC.h"
#import <UShareUI/UShareUI.h>
#import "JuBaoAlertView.h"
#import "RegistViewController.h"
@interface FeedDetailsVC ()<UITableViewDelegate,UITableViewDataSource,VTAPIManagerCallBackDelegate,VTAPIManagerParamSource,VottingViewDelegate,FeedDetailTableViewCellDelegate> {
    BOOL        _showMoreContent;
}

@property (nonatomic,strong)UITableView     *detailTableView;
@property (nonatomic,strong)UIView          *footerView;
@property (nonatomic,strong)UIBarButtonItem *shouCangItem;
@property (nonatomic,strong)UIBarButtonItem *shareItem;
@property (nonatomic,strong)UIBarButtonItem *reportedItem;
@property (nonatomic,strong)FeedDetailModel *feedDetailModel;
@property (nonatomic,strong)NSMutableArray <CommentModel *> *totalComments;
@property (nonatomic,strong)NSMutableArray <CommentModel *> *hotestNegComments;
@property (nonatomic,strong)NSMutableArray <CommentModel *> *hotestPosComments;
@property (nonatomic,strong)FeedDetailApiManager        *feedDetailApiManager;
@property (nonatomic,strong)AddCollectionApiManager     *addCollectedApiManger;
@property (nonatomic,strong)CancelCollectionApiManager  *cancelCollectedApiManager;
@property (nonatomic,strong)MBProgressHUD               *feedDetailHUD;
@property (nonatomic,assign)VouteHeaderViewState        vouteHeaderState;
@property (nonatomic,strong)NSMutableArray          *commentsList;

@end

@implementation FeedDetailsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //初始筛选状态
    _vouteHeaderState.VouteHeaderViewStateWillShowYesState = YES;
    _vouteHeaderState.VouteHeaderViewStateWillShowNoState = YES;
    [self.view addSubview:self.detailTableView];
    [self configNavigationItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterSliderValueDidChanged:) name:VoteSliderFilterViewStatusDidChangedNotificationName object:nil];
    [self.feedDetailApiManager loadData];
}
#pragma mark -- Public Method
- (void)configNavigationItem {
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"投票话题";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.navigationItem.rightBarButtonItems = @[self.reportedItem,self.shareItem,self.shouCangItem];
}

- (void)layoutSubViews {
    
//    self.totalComments = [self.feedDetailModel.hot mutableCopy];
//    
//    [self.view addSubview:self.footerView];
//    
//    UIButton * voteBtn = [self.footerView viewWithTag:2001];
//    if ([self.feedDetailModel.voted intValue] == 1) {
//        [voteBtn setTitle:@"立即评论" forState:UIControlStateNormal];
//    }
//    else {
//        [voteBtn setTitle:@"立即投票" forState:UIControlStateNormal];
//    }
//    UIButton *shouCangBtn = self.shouCangItem.customView;
//    if ([self.feedDetailModel.collected intValue] == 1) {
//        shouCangBtn.selected = YES;
//    }
//    else {
//        shouCangBtn.selected = NO;
//    }
    [self.detailTableView reloadData];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.feedDetailModel.share_title descr:self.feedDetailModel.share_desc thumImage:self.feedDetailModel.share_pic];
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
        //        [self showMessage: inView:<#(UIView *)#>];
    }];
}
#pragma mark -- action method
//去投票、去评论
- (void)voteClicked:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"立即投票"]) {
        [self showVoteView];
    }
    else {
        [self toComment];
    }
}
- (void)shareAction:(UIButton *)sender {
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
        JuBaoAlertView * alertView = [[JuBaoAlertView alloc] initWithFid:self.fid];
        alertView.presentViewController = self;
        [alertView showInView:self.navigationController.view];
    }
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
        VottingView * voteView = [[VottingView alloc] init];
        voteView.presentViewController = self;
//        voteView.fid = self.fid;
        voteView.delegate = self;
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [voteView showInView:window];
    }
}
- (void)toComment {
    if (![VTAppContext shareInstance].isOnline) {//未登录
        RegistViewController *registVC = [[RegistViewController alloc] init];
        UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:registVC];
        WEAKSELF;
        registVC.completionhandle = ^ {
            [weakSelf toComment];
        };
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    else {
        AddCommentVC * addCommentVC =[[AddCommentVC alloc] init];
        addCommentVC.fid = self.fid;
//        addCommentVC.side = self.feedDetailModel.side;
        [self.navigationController pushViewController:addCommentVC animated:YES];
    }
}
//收藏、取消收藏
- (void)collected:(UIButton *)sender {
    
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
//        if (self.feedDetailModel) {
//            if ([self.feedDetailModel.collected intValue] == 1) {
//                [self.cancelCollectedApiManager loadData];
//                self.feedDetailModel.collected = @"0";
//                sender.selected = NO;
//            }
//            else {
//                [self.addCollectedApiManger loadData];
//                self.feedDetailModel.collected = @"1";
//                sender.selected = YES;
//            }
//        }
//        else {
//            if (sender.selected) {
//                [self.cancelCollectedApiManager loadData];
//                sender.selected = NO;
//            }
//            else {
//                [self.addCollectedApiManger loadData];
//                sender.selected = YES;
//            }
//        }
    }
}
- (void)filterSliderValueDidChanged:(NSNotification *)notic {
    
    NSInteger state = [notic.userInfo[@"state"] integerValue];
    if (state == 0) {
        _vouteHeaderState.VouteHeaderViewStateWillShowYesState = YES;
        _vouteHeaderState.VouteHeaderViewStateWillShowNoState = YES;
    }
    else if (state == 1) {
        _vouteHeaderState.VouteHeaderViewStateWillShowYesState = YES;
        _vouteHeaderState.VouteHeaderViewStateWillShowNoState = NO;
    }
    else {
        _vouteHeaderState.VouteHeaderViewStateWillShowYesState = NO;
        _vouteHeaderState.VouteHeaderViewStateWillShowNoState = YES;
    }
    [self.detailTableView reloadData];
}
#pragma mark -- FeedDetailTableViewCellDelegate
- (void)feedDetailTableViewCell:(FeedDetailTableViewCell *)cell voteCountView:(VoteCountVSView *)voteCountView didClickedToVote:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self.detailTableView indexPathForCell:cell];
    if (indexPath.section == 1) {
        [self showVoteView];
    }
}
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
//        if ([self.feedDetailModel.side intValue]) {//正方
//            if ([comment.type isEqualToString:@"neg"]) {
//                [self showMessage:@"只能为您投票的一方的评论点赞" inView:self.view];
//                return;
//            }
//        }
//        else {
//            if ([comment.type isEqualToString:@"pos"]) {
//                [self showMessage:@"只能为您投票的一方的评论点赞" inView:self.view];
//                return;
//            }
//        }
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
//#pragma mark -- VottingViewDelegate
//- (void)vottingView:(VottingView *)voteView didVotedInSide:(int)side posvotes:(int)posVote negvotes:(int)negvote {
//    self.feedDetailModel.side = [NSString stringWithFormat:@"%d",side];
//    self.feedDetailModel.voted = @"1";
//    self.feedDetailModel.pos_vote = [NSString stringWithFormat:@"%d",posVote];
//    self.feedDetailModel.neg_vote = [NSString stringWithFormat:@"%d",negvote];
//    UIButton * voteBtn = [self.footerView viewWithTag:2001];
//    if ([self.feedDetailModel.voted intValue] == 1) {
//        [voteBtn setTitle:@"立即评论" forState:UIControlStateNormal];
//    }
//    else {
//        [voteBtn setTitle:@"立即投票" forState:UIControlStateNormal];
//    }
//    [self.detailTableView reloadData];
//}
- (void)vottingView:(VottingView *)voteView didClickedShareItem:(NSUInteger)sharePlatformOption {
    UMSocialPlatformType platformType;
    if (sharePlatformOption == 0) {
        platformType = UMSocialPlatformType_QQ;
    }
    else if (sharePlatformOption == 1) {
        platformType = UMSocialPlatformType_WechatSession;
    }
    else {
        platformType = UMSocialPlatformType_Sina;
    }
    [self shareWebPageToPlatformType:platformType];
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.feedDetailApiManager) {
        self.feedDetailHUD = [self showHUDLoadingWithMessage:@"" inView:self.view];
    }
    if ([manager isKindOfClass:[UpForCommentApiManager class]]) {
//        return @{@"side":self.feedDetailModel.side};
    }
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if (manager == self.feedDetailApiManager) {
        [self hiddenHUD:self.feedDetailHUD];
        self.feedDetailModel = [manager fetchDataWithReformer:[FeedDetailReformer new]];
        [self layoutSubViews];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    if (manager == self.feedDetailApiManager) {
        [self hiddenHUD:self.feedDetailHUD];
        [self showMessage:manager.errorMessage inView:self.view];
    }
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.feedDetailModel) {
        if (!self.feedDetailModel.voted) {//是否已投票 未投票用户不允许查看更多评论
            return 3;
        }
        return 4;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.feedDetailModel) {
        if (section == 3) {
            return self.commentsList.count+1;
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
        cellId =FeedDetailTableViewFeedContentCellIdentifier;
    }else if (indexPath.section == 2) {
        cellId =FeedDetailTableViewPointVSCellIdentifier;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
//            cellId = FeedDetailTableViewMoreCommentCellIdentifier;

        } else {
            cellId = FeedDetailTableViewCommentCellIdentifier;
        }
    }
    FeedDetailTableViewCell *cell = [FeedDetailTableViewCell loadCellWithTableView:tableView reuseIdentifier:cellId];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_feedDetailModel) {
       
    }
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 4) {
        
        return 0;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 100;
    }
    else if (indexPath.section == 1) {
        return 50;
    }
    else if (indexPath.section == 2) {

        return 220 + self.feedDetailModel.contentHeight;
    }
    else if (indexPath.section == 4) {
        return 30;
    }
    if (indexPath.row != 0) {
        CommentModel * comment;
        comment = self.totalComments[indexPath.row-1];
        return comment.contentHeight+60;
    }
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //未登录没有入口查看更多评论
        MoreCommentVC * commentVC = [[MoreCommentVC alloc] init];
        commentVC.fid = self.fid;
//        commentVC.side = self.feedDetailModel.side;
//        commentVC.totalCommentCount = [self.feedDetailModel.pos_comment intValue] + [self.feedDetailModel.neg_comment intValue];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
    else if (indexPath.section == 3 && indexPath.row != 0) {//查看其他人信息
        CommentModel * comment;
        if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            if (indexPath.row !=0) {
                comment = self.totalComments[indexPath.row-1];
            }
        }
        else if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && !_vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            
            if (indexPath.row !=0) {
//                comment = self.feedDetailModel.pos_hotcomments[indexPath.row-1];
            }
        }
        else if (!_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            if (indexPath.row !=0) {
//                comment = self.feedDetailModel.neg_hotcomments[indexPath.row-1];
            }
        }
        OtherUserCenterVC * userVC = [[OtherUserCenterVC alloc] init];
//        userVC.uid = comment.uid;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3 && indexPath.row == self.totalComments.count-1) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
    }
    else {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark -- getter
- (UITableView *)detailTableView {
    
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStylePlain];
        _detailTableView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        _detailTableView.delegate   = self;
        _detailTableView.dataSource = self;
        _detailTableView.tableFooterView = [UIView new];
    }
    return _detailTableView;
}
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-65, SCREEN_WIDTH, 65)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        voteButton.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 45);
        voteButton.backgroundColor = UIRGBColor(245, 45, 84, 1.0f);
        [voteButton setTitle:@"立即投票" forState:UIControlStateNormal];
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
- (UIBarButtonItem *)shouCangItem {
    
    if (!_shouCangItem) {
        UIButton * button = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 28, 28);
            btn.backgroundColor = [UIColor clearColor];
            [btn setImage:[UIImage imageNamed:@"icon_shoucang.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"icon_shoucangxz.png"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(collected:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        _shouCangItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _shouCangItem;
}
- (UIBarButtonItem *)shareItem {
    
    if (!_shareItem) {
        UIButton * button = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 28, 28);
            btn.backgroundColor = [UIColor clearColor];

            [btn setImage:[UIImage imageNamed:@"icon_fenxiang.png"] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        _shareItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _shareItem;
}
- (UIBarButtonItem *)reportedItem {
    
    if (!_reportedItem) {
        UIButton * button = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 28, 28);
            btn.backgroundColor = [UIColor clearColor];
            
            [btn setImage:[UIImage imageNamed:@"icon_jubao.png"] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(jubaoActionClicked) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        _reportedItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _reportedItem;
}
- (FeedDetailApiManager *)feedDetailApiManager {
    
    if (!_feedDetailApiManager) {
        _feedDetailApiManager = [[FeedDetailApiManager alloc] initWithHash:self.feedhash];
        _feedDetailApiManager.delegate = self;
        _feedDetailApiManager.paramsourceDelegate = self;
    }
    return _feedDetailApiManager;
}
- (CancelCollectionApiManager *)cancelCollectedApiManager {
    if (!_cancelCollectedApiManager) {
        _cancelCollectedApiManager = [[CancelCollectionApiManager alloc] initWithFid:self.fid];
        _cancelCollectedApiManager.paramsourceDelegate = self;
        _cancelCollectedApiManager.delegate = self;
    }
    return _cancelCollectedApiManager;
}
- (AddCollectionApiManager *)addCollectedApiManger {
    if (!_addCollectedApiManger) {
        _addCollectedApiManger = [[AddCollectionApiManager alloc] initWithFid:self.fid];
        _addCollectedApiManger.delegate = self;
        _addCollectedApiManger.paramsourceDelegate = self;
    }
    return _addCollectedApiManger;
}
- (NSMutableArray *)totalComments {
    
    if (!_totalComments) {
        _totalComments = [NSMutableArray arrayWithCapacity:0];
    }
    return _totalComments;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
