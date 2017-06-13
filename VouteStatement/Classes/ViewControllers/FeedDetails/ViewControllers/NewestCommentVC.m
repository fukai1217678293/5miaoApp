//
//  NewestCommentVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "NewestCommentVC.h"
#import "VouteHeaderView.h"
#import "AddCommentVC.h"
#import "NewestCommentApiManager.h"
#import "MoreCommentVC.h"
#import "CommentModel.h"
#import "FeedDetailReformer.h"
#import "VoteSliderView.h"
#import "UpForCommentApiManager.h"
#import "OtherUserCenterVC.h"
@interface NewestCommentVC ()<UITableViewDataSource,UITableViewDelegate,VTAPIManagerParamSource,VTAPIManagerCallBackDelegate>

@property (nonatomic,strong)UITableView             *commentTableView;
@property (nonatomic,strong)NSString                *lastAnchor;
@property (nonatomic,strong)NewestCommentApiManager *apimanager;
@property (nonatomic,strong)NSMutableArray          *latestComments;
@property (nonatomic,strong)NSMutableArray          *latestPosComments;
@property (nonatomic,strong)NSMutableArray          *latestNegComments;
@property (nonatomic,assign)VouteHeaderViewState    vouteHeaderState;

@end

@implementation NewestCommentVC
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIRGBColor(241, 241, 241, 1.0f);
    [self.view addSubview:self.commentTableView];
    WEAKSELF;
    [_commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    //筛选初始状态
    _vouteHeaderState.VouteHeaderViewStateWillShowNoState = YES;
    _vouteHeaderState.VouteHeaderViewStateWillShowYesState = YES;
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vouteHeaderFilerNotification:) name:VoteSliderFilterViewStatusDidChangedNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddNewComment:) name:AddCommentViewControllerDidSubmitNewCommentNotificationName object:nil];
}

#pragma mark -- action method
- (void)headerRefresh {
    if ([self.commentTableView.mj_footer isRefreshing]) {
        [self.apimanager cancelAllRequest];
        [self.commentTableView.mj_footer endRefreshing];
    }
    if (self.commentTableView.mj_footer.state == MJRefreshStateNoMoreData) {
        self.commentTableView.mj_footer.state = MJRefreshStateIdle;
    }
    self.lastAnchor = @"0";
    [self.apimanager loadData];
}
- (void)footerRefresh {
    if ([self.commentTableView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.commentTableView.mj_footer endRefreshing];
        return;
    }
    if (self.latestComments.count) {
        CommentModel * comment = [self.latestComments lastObject];
        self.lastAnchor =comment.cid;
    }
    [self.commentTableView.mj_footer beginRefreshing];
    [self.apimanager loadData];
}

#pragma mark -- Notification
- (void)vouteHeaderFilerNotification:(NSNotification *)notification {
    NSInteger state = [notification.userInfo[@"state"] integerValue];
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
    [self.commentTableView reloadData];
}
- (void)didAddNewComment:(NSNotification *)notification {
    
    [self.commentTableView.mj_header beginRefreshing];
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.apimanager) {
        return @{@"anchor":self.lastAnchor};
    }
    else if ([manager isKindOfClass:[UpForCommentApiManager class]]) {
        MoreCommentVC *parentVC = (MoreCommentVC *)self.parentViewController;

        return @{@"side":parentVC.side};
    }
    
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {

    FeedDetailReformer * reformer = [[FeedDetailReformer alloc] init];
    NSDictionary * resultDict = [manager fetchDataWithReformer:reformer];
    NSArray * latestArray = resultDict[@"latest"];
    
    if ([self.commentTableView.mj_header isRefreshing]) {
        self.latestComments = [latestArray mutableCopy];
        self.latestNegComments = [resultDict[@"latestneg"] mutableCopy];
        self.latestPosComments = [resultDict[@"latestpos"] mutableCopy];
        if (!latestArray.count || !latestArray) {
            [self.commentTableView.mj_header endRefreshing];
            [self.commentTableView.mj_footer setState:MJRefreshStateNoMoreData];
            [self.commentTableView reloadData];
            return;
        }
    }
    else {
        
        if (!latestArray.count || !latestArray) {
            
            [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        else {
            [self.latestComments addObjectsFromArray:[latestArray mutableCopy]];
            [self.latestNegComments addObjectsFromArray:resultDict[@"latestneg"]];
            [self.latestPosComments addObjectsFromArray: resultDict[@"latestpos"]];
        }
    }
    [self.commentTableView.mj_header endRefreshing];
    [self.commentTableView.mj_footer endRefreshing];
    
    [self.commentTableView reloadData];
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    if ([self.commentTableView.mj_header isRefreshing]) {
        [self.commentTableView.mj_header endRefreshing];
    }
    if ([self.commentTableView.mj_footer isRefreshing]) {
        [self.commentTableView.mj_footer endRefreshing];
    }
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark -- FeedDetailTableViewCellDelegate
- (void)feedDetailTableViewCell:(FeedDetailTableViewCell *)cell
                    commentView:(CommentView *)commentView
        didClickedDianZanAction:(UIButton *)sender
                   commentModel:(CommentModel *)comment {
    MoreCommentVC *parentVC = (MoreCommentVC *)self.parentViewController;
//    if ([parentVC.side intValue]) {//正方
//        if ([comment.type isEqualToString:@"neg"]) {
//            [parentVC showMessage:@"只能为您投票的一方的评论点赞" inView:parentVC.view];
//            return;
//        }
//    }
//    else {
//        if ([comment.type isEqualToString:@"pos"]) {
//            [parentVC showMessage:@"只能为您投票的一方的评论点赞" inView:parentVC.view];
//            return;
//        }
//    }
//    if (sender.selected == YES) {
////        [parentVC showMessage:@"您已经为Ta点过赞啦~~" inView:parentVC.view];
//        return;
//    }
//    if ([comment.uped intValue]) {
//        sender.selected = YES;
////        [parentVC showMessage:@"您已经为Ta点过赞啦~~" inView:parentVC.view];
//        return;
//    }
    UpForCommentApiManager *apiManager = [[UpForCommentApiManager alloc] initWithCid:comment.cid];
    apiManager.delegate = self;
    apiManager.paramsourceDelegate = self;
    sender.selected = YES;
    comment.up = [NSString stringWithFormat:@"%d",[comment.up intValue]+1];
    comment.uped = @"1";
    [sender setTitle:[NSString stringWithFormat:@"%@",comment.up] forState:UIControlStateNormal];
    [apiManager loadData];
    
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count;
    if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        count = self.latestComments.count+1;
    }
    else if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && !_vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        count = self.latestPosComments.count + 1 ;
    }
    else if (!_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        count  = self.latestNegComments.count + 1;
    }
    else {
        count = 1;
    }
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellId;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cellId = FeedDetailTableViewPointVSCellIdentifier;
    }
    else {
        cellId = FeedDetailTableViewCommentCellIdentifier;
    }
    FeedDetailTableViewCell * cell = [FeedDetailTableViewCell loadCellWithTableView:tableView reuseIdentifier:cellId];
    CommentModel * comment;
    if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        if (indexPath.row !=0) {
            comment = self.latestComments[indexPath.row-1];
            cell.comment = comment;
        }
    }
    else if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && !_vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        
        if (indexPath.row !=0) {
            comment = self.latestPosComments[indexPath.row-1];
            cell.comment = comment;
        }
    }
    else if (!_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        if (indexPath.row !=0) {
            comment = self.latestNegComments[indexPath.row-1];
            cell.comment = comment;
        }
    }
    if (indexPath.row != 0) {
        cell.delegate = self;
    }
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0) {
        CommentModel * comment;
        if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            if (indexPath.row !=0) {
                comment = self.latestComments[indexPath.row-1];
            }
        }
        else if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && !_vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            
            if (indexPath.row !=0) {
                comment = self.latestPosComments[indexPath.row-1];
            }
        }
        else if (!_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            if (indexPath.row !=0) {
                comment = self.latestNegComments[indexPath.row-1];
            }
        }
        OtherUserCenterVC * userVC = [[OtherUserCenterVC alloc] init];
//        userVC.uid = comment.uid;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    }
    else {
        CommentModel * comment;
        if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            comment = self.latestComments[indexPath.row-1];
        }
        else if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && !_vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            
            comment = self.latestPosComments[indexPath.row-1];
        }
        else if (!_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            comment = self.latestNegComments[indexPath.row-1];
        }
        return comment.contentHeight+60;
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark -- getter
- (UITableView *)commentTableView {
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _commentTableView.backgroundColor = UIRGBColor(241, 241, 241, 1.0f);
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.tableFooterView = [UIView new];
        _commentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData ];
        _commentTableView.mj_footer = footer;
        [_commentTableView.mj_header beginRefreshing];
    }
    return _commentTableView;
}
- (NewestCommentApiManager *)apimanager {
    if (!_apimanager) {
        
        MoreCommentVC *parentVC = (MoreCommentVC *)self.parentViewController;
        
        _apimanager = [[NewestCommentApiManager alloc] initWithFid:parentVC.fid];
        _apimanager.paramsourceDelegate = self;
        _apimanager.delegate = self;
    }
    return _apimanager;
}

#pragma mark -- dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
