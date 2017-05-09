//
//  UserCenterVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/24.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "UserCenterVC.h"
#import "UserHeaderView.h"
#import "UserInfoApiManager.h"
#import "UserInfoReformer.h"
#import "SettingInformationVC.h"
#import "CommonSettingVC.h"
#import "MyCreateFeedListVC.h"
#import "MyJoinFeedListVC.h"
#import "MyCircleFeedListVC.h"
#import "NotificationListVC.h"
#import "NotificationManager.h"

NSString * const UserCenterViewControllerWillUpdateNotification = @"UserCenterViewControllerWillUpdateNotification";

@interface UserCenterVC ()<UITableViewDelegate,UITableViewDataSource,VTAPIManagerParamSource,VTAPIManagerCallBackDelegate>

@property (nonatomic,strong)UITableView *userTableView;
@property (nonatomic,strong)UserHeaderView *headerView;
@property (nonatomic,strong)UserInfoApiManager *userinfoApiManager;
@property (nonatomic,strong)UIButton *settingButton;
@property (nonatomic,strong)NSArray <NSArray <NSString *>*>*dataSources;
@property (nonatomic,copy)NSDictionary *redPointNotificationObj;
@end

@implementation UserCenterVC
@synthesize redPointNotificationObj = _redPointNotificationObj;

//去掉懒加载  红点提示需要在底部出现红点提示即刷新
- (instancetype)init {
    if (self = [super init]) {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:self.userTableView];
        [self.view addSubview:self.settingButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRedPointDidReceiveNewData:) name:NotificationManagerDidReceiveNewData object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInformation) name:UserCenterViewControllerWillUpdateNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self  updateUserInformation];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark -- action method
- (void)settingClicked {
    
    CommonSettingVC *settingVC =[[CommonSettingVC alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark -- Private Method
- (void)pushToMyCreateVC {
    MyCreateFeedListVC * createVC =[[MyCreateFeedListVC alloc] init];
    createVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:createVC animated:YES];
}
- (void)pushToMyJoinedVC {
    MyJoinFeedListVC *joinedVC = [[MyJoinFeedListVC alloc] init];
    joinedVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:joinedVC animated:YES];
}
- (void)pushToMyCircleVC {
    MyCircleFeedListVC *circlesVC = [[MyCircleFeedListVC alloc] init];
    circlesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:circlesVC animated:YES];
}
- (void)pushToNotiesVC {
    NotificationListVC *notiVC = [[NotificationListVC alloc] init];
    notiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notiVC animated:YES];
}
#pragma mark -- Notification
- (void)updateUserInformation {
    [self.userinfoApiManager loadData];
}
- (void)notificationRedPointDidReceiveNewData:(NSNotification *)notic {
    self.redPointNotificationObj = notic.object;
    
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {

    if (manager == self.userinfoApiManager) {
        return @{};
    }
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if (manager == self.userinfoApiManager) {
        UserInfoReformer * reformer = [[UserInfoReformer alloc] init];
        [manager fetchDataWithReformer:reformer];
        [self.headerView updateUserInformation:nil];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSources.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString * title = self.dataSources[indexPath.section][0];
    UIImage  * titleIcon = [UIImage imageNamed:self.dataSources[indexPath.section][1]];
    UIButton *titleButton = [cell viewWithTag:100+indexPath.section];
    if (!titleButton) {
        titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(10, 0, 150, cell.height);
        titleButton.backgroundColor = [UIColor clearColor];
        [titleButton setImage:titleIcon forState:UIControlStateNormal];
        [titleButton setTitle:title forState:UIControlStateNormal];
        [titleButton setTitleColor:UIRGBColor(98, 98, 98, 1.0f) forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
        titleButton.tag = indexPath.section + 100;
        titleButton.userInteractionEnabled = NO;
        [cell addSubview:titleButton];
    }
    UIImageView *redPointImg = (UIImageView *)[cell viewWithTag:2000];
    if (indexPath.section >1) {
        if (!redPointImg) {
            redPointImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dian.png"]];
            redPointImg.tag = 2000;
            redPointImg.frame = CGRectMake(SCREEN_WIDTH-52, 18, 8, 8);
            [cell addSubview:redPointImg];
        }
        if (indexPath.section == 2) {
            int circleHaveUnread = [self.redPointNotificationObj[@"circle"] intValue];
            if (circleHaveUnread) {
                redPointImg.hidden = NO;
            } else {
                redPointImg.hidden = YES;
            }
        } else {
            int feedHaveUnread = [self.redPointNotificationObj[@"feed"] intValue];
            if (feedHaveUnread) {
                redPointImg.hidden = NO;
            } else {
                redPointImg.hidden = YES;
            }
        }
    } else {
        if (redPointImg) {
            [redPointImg removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return 0.0f;
    }
    return 10.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:NSSelectorFromString(self.dataSources[indexPath.section][2])];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -- setter
- (void)setRedPointNotificationObj:(NSDictionary *)redPointNotificationObj {
    _redPointNotificationObj = redPointNotificationObj;
    if (self.userTableView) {
        [self.userTableView reloadData];
    }
}
#pragma mark -- getter
- (UITableView *)userTableView {
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _userTableView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        _userTableView.delegate     =   self;
        _userTableView.dataSource   =   self;
        _userTableView.tableHeaderView = self.headerView;
        _userTableView.tableFooterView = [UIView new];
        [_userTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
 
    return _userTableView;
}
- (UserInfoApiManager *)userinfoApiManager {
    
    if (!_userinfoApiManager) {
        
        _userinfoApiManager = [[UserInfoApiManager alloc] init];
        _userinfoApiManager.delegate = self;
        _userinfoApiManager.paramsourceDelegate = self;
    }
    return _userinfoApiManager;
}
- (UserHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 210)];
        WEAKSELF;
        _headerView.headerButtonDidClicked = ^(UIButton *sender){
            
            SettingInformationVC * setInfoVC = [[SettingInformationVC alloc] init];
            setInfoVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:setInfoVC animated:YES];
        };
        _headerView.headerJoinedFeedDidClicked = ^(UIButton *sender){
            MyJoinFeedListVC *joinedVC = [[MyJoinFeedListVC alloc] init];
            joinedVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:joinedVC animated:YES];
        };
    }
    return _headerView;
}
- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingButton.frame = CGRectMake(SCREEN_WIDTH-45, 30, 38, 30);
        [_settingButton setImage:[UIImage imageNamed:@"icon_set.png"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(settingClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}
- (NSArray <NSArray <NSString *> *> *)dataSources {
    return @[@[@"我的创建",@"icon_mycj.png",@"pushToMyCreateVC"],
             @[@"我的参与",@"icon_mycy.png",@"pushToMyJoinedVC"],
             @[@"我的圈子",@"icon_quanquan.png",@"pushToMyCircleVC"],
             @[@"我的通知",@"icon_tongzhi.png",@"pushToNotiesVC"]];
}
- (NSDictionary *)redPointNotificationObj {
    if (!_redPointNotificationObj) {
        _redPointNotificationObj = @{@"circle":@"0",
                                     @"feed":@"0"};
    }
    return _redPointNotificationObj;
}
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
