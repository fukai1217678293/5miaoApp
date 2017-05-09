//
//  HotestCommentVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "HotestCommentVC.h"
#import "VouteHeaderView.h"
#import "AddCommentVC.h"
#import "HotestCommentApiManager.h"
#import "MoreCommentVC.h"
#import "CommentModel.h"
#import "FeedDetailReformer.h"
#import "FeedDetailTableViewCell.h"
#import "VoteSliderView.h"
#import "UpForCommentApiManager.h"
#import "OtherUserCenterVC.h"
@interface HotestCommentVC ()<UITableViewDataSource,UITableViewDelegate,VTAPIManagerParamSource,VTAPIManagerCallBackDelegate,FeedDetailTableViewCellDelegate>

@property (nonatomic,strong)UITableView             *commentTableView;
@property (nonatomic,assign)NSUInteger              page;
@property (nonatomic,strong)NSMutableArray          *hotestComments;
@property (nonatomic,strong)NSMutableArray          *hotestPosComments;
@property (nonatomic,strong)NSMutableArray          *hotestNegComments;
@property (nonatomic,strong)HotestCommentApiManager *apimanager;
@property (nonatomic,strong)UpForCommentApiManager  *upCommentApiManager;
@property (nonatomic,assign)VouteHeaderViewState    vouteHeaderState;

@end

@implementation HotestCommentVC

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
    self.page = 1;
    [self.apimanager loadData];
}
- (void)footerRefresh {
    if ([self.commentTableView.mj_header isRefreshing]) {//header刷新时不允许 footer刷新
        [self.commentTableView.mj_footer endRefreshing];
        return;
    }
    if (self.hotestComments.count) {
        self.page +=1;
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

#pragma mark -- FeedDetailTableViewCellDelegate
- (void)feedDetailTableViewCell:(FeedDetailTableViewCell *)cell
                    commentView:(CommentView *)commentView
        didClickedDianZanAction:(UIButton *)sender
                   commentModel:(CommentModel *)comment {
    MoreCommentVC *parentVC = (MoreCommentVC *)self.parentViewController;
    if ([parentVC.side intValue]) {//正方
//        if ([comment.type isEqualToString:@"neg"]) {
//            [parentVC showMessage:@"只能为您投票的一方的评论点赞" inView:parentVC.view];
//            return;
//        }
    }
    else {
//        if ([comment.type isEqualToString:@"pos"]) {
//            [parentVC showMessage:@"只能为您投票的一方的评论点赞" inView:parentVC.view];
//            return;
//        }
    }
    if (sender.selected == YES) {
        //        [parentVC showMessage:@"您已经为Ta点过赞啦~~" inView:parentVC.view];
        return;
    }
//    if ([comment.uped intValue]) {
//        sender.selected = YES;
//        //        [parentVC showMessage:@"您已经为Ta点过赞啦~~" inView:parentVC.view];
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
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.apimanager) {
        return @{@"page":@(self.page)};
    }
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    
    FeedDetailReformer * reformer = [[FeedDetailReformer alloc] init];
    NSDictionary * resultDict = [manager fetchDataWithReformer:reformer];
    NSArray * latestArray = resultDict[@"hotest"];
    
    if ([self.commentTableView.mj_header isRefreshing]) {
        self.hotestComments = [latestArray mutableCopy];
        self.hotestNegComments = [resultDict[@"hotestneg"] mutableCopy];
        self.hotestPosComments = [resultDict[@"hotestpos"] mutableCopy];
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
            [self.hotestComments addObjectsFromArray:[latestArray mutableCopy]];
            [self.hotestNegComments addObjectsFromArray:resultDict[@"hotestneg"]];
            [self.hotestPosComments addObjectsFromArray: resultDict[@"hotestpos"]];
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
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count;
    if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        count = self.hotestComments.count+1;
    }
    else if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && !_vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        count = self.hotestPosComments.count + 1 ;
    }
    else if (!_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        count  = self.hotestNegComments.count + 1;
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
            comment = self.hotestComments[indexPath.row-1];
            cell.comment = comment;
        }
    }
    else if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && !_vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        
        if (indexPath.row !=0) {
            comment = self.hotestPosComments[indexPath.row-1];
            cell.comment = comment;
        }
    }
    else if (!_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
        if (indexPath.row !=0) {
            comment = self.hotestNegComments[indexPath.row-1];
            cell.comment = comment;
        }
    }
    if (indexPath.row != 0) {
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
#pragma mark -- UITableViewDelegate
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
            comment = self.hotestComments[indexPath.row-1];
        }
        else if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && !_vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            
            comment = self.hotestPosComments[indexPath.row-1];
        }
        else if (!_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            comment = self.hotestNegComments[indexPath.row-1];
        }
        return comment.contentHeight+60;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0) {
        CommentModel * comment;
        if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            if (indexPath.row !=0) {
                comment = self.hotestComments[indexPath.row-1];
            }
        }
        else if (_vouteHeaderState.VouteHeaderViewStateWillShowYesState && !_vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            
            if (indexPath.row !=0) {
                comment = self.hotestPosComments[indexPath.row-1];
            }
        }
        else if (!_vouteHeaderState.VouteHeaderViewStateWillShowYesState && _vouteHeaderState.VouteHeaderViewStateWillShowNoState) {
            if (indexPath.row !=0) {
                comment = self.hotestNegComments[indexPath.row-1];
            }
        }
        OtherUserCenterVC * userVC = [[OtherUserCenterVC alloc] init];
//        userVC.uid = comment.uid;
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

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
- (HotestCommentApiManager *)apimanager {
    if (!_apimanager) {
        
        MoreCommentVC *parentVC = (MoreCommentVC *)self.parentViewController;
        
        _apimanager = [[HotestCommentApiManager alloc] initWithFid:parentVC.fid];
        _apimanager.paramsourceDelegate = self;
        _apimanager.delegate = self;
    }
    return _apimanager;
}
- (UpForCommentApiManager *)upCommentApiManager{
    if (!_upCommentApiManager) {
        _upCommentApiManager = [[UpForCommentApiManager alloc] init];
        _upCommentApiManager.delegate = self;
        _upCommentApiManager.paramsourceDelegate = self;
    }
    return _upCommentApiManager;
}
#pragma mark -- dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
