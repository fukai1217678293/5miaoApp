//
//  CommonSettingVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CommonSettingVC.h"
#import "BaseTabBarController.h"
#import "RegistProtocolVC.h"
@interface CommonSettingVC ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSArray         * _titleArray;
}
@property (nonatomic,strong)UITableView *settingTableView;
@property (nonatomic,strong)UIView *footerView;
@end

@implementation CommonSettingVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configNavigationItem];
    [self configVariable];
    [self.view addSubview:self.settingTableView];
}
- (void)configVariable {
    _titleArray = @[@"清空缓存",@"用户协议",@"关于"];
}
- (void)configNavigationItem {
    
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
}
#pragma mark - PrivateMethod 
- (void)clearHDMemory {
    
}
- (void)registProtocol {
    [self.navigationController pushViewController:[RegistProtocolVC new] animated:YES];
}
#pragma mark -- action method
- (void)exitLogin {
    [[VTAppContext shareInstance] clearUserInfo];
    BaseTabBarController * rootVC = (BaseTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    rootVC.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.textColor = UIRGBColor(90, 90, 90, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:14.5f];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//清空缓存
        [self clearHDMemory];
    }
    else if (indexPath.row == 1){
        [self registProtocol];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark -- getter
- (UITableView *)settingTableView {
    
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        _settingTableView.backgroundColor =UIRGBColor(242, 242, 242, 1.0f);
        _settingTableView.tableFooterView = self.footerView;
        [_settingTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _settingTableView;
}
- (UIView *)footerView {
    
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _footerView.backgroundColor = [UIColor clearColor];
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exitButton.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, 40);
        exitButton.layer.cornerRadius = 5.0f;
        exitButton.layer.masksToBounds = YES;
        exitButton.backgroundColor = UIRGBColor(245, 45, 84, 1.0f);
        [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        exitButton.titleLabel.font =[UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [exitButton addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:exitButton];
    }
    return _footerView;
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
