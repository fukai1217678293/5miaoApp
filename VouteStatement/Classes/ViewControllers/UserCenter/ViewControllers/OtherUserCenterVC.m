//
//  OtherUserCenterVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "OtherUserCenterVC.h"
#import "UserHeaderView.h"
#import "OtherUserInfoApiManager.h"
#import "UserInfoReformer.h"
#import "UserInfoModel.h"
#import "OtherJoinedFeedListVC.h"
@interface OtherUserCenterVC ()<UITableViewDelegate,UITableViewDataSource,VTAPIManagerParamSource,VTAPIManagerCallBackDelegate>


@property (nonatomic,strong)UITableView             *userTableView;
@property (nonatomic,strong)UserHeaderView          *headerView;
@property (nonatomic,strong)OtherUserInfoApiManager *userinfoApiManager;
@property (nonatomic,strong)UserInfoModel           *userModel;
@end

@implementation OtherUserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationItem];
    [self.view addSubview:self.userTableView];
    [self.userinfoApiManager loadData];
}
- (void)configNavigationItem {
    
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"用户详情";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
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
        
        self.userModel = [manager fetchDataWithReformer:reformer];
        
        [self.headerView updateUserInformation:self.userModel];
        
        UITableViewCell * cell = [self.userTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel * signatureLab = [cell viewWithTag:100];
        signatureLab.text = self.userModel.signature.length ? self.userModel.signature : @"这个人很懒,什么都没有留下";
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        UILabel * remarkSignLab = [cell viewWithTag:100];
        
        if (!remarkSignLab) {
            
            remarkSignLab = ({
                
                UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
                label.backgroundColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = @"这个人很懒,什么都没有留下";
                label.textColor = UIRGBColor(196, 196, 196, 1.0f);
                label.font = [UIFont systemFontOfSize:14];
                label.tag = 100;
                [cell addSubview:label];
                label;
            });
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    return cell;
}
#pragma mark -- UITableViewDelegate


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
- (OtherUserInfoApiManager *)userinfoApiManager {
    
    if (!_userinfoApiManager) {
        
        _userinfoApiManager = [[OtherUserInfoApiManager alloc] initWithUid:self.uid];
        _userinfoApiManager.delegate = self;
        _userinfoApiManager.paramsourceDelegate = self;
    }
    return _userinfoApiManager;
}
- (UserHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
        WEAKSELF;
        
        _headerView.headerJoinedFeedDidClicked = ^(UIButton *sender){
            OtherJoinedFeedListVC * listVC = [[OtherJoinedFeedListVC alloc] init];
            listVC.uid = weakSelf.uid;
            [weakSelf.navigationController pushViewController:listVC animated:YES];
        };
    }
    return _headerView;
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
