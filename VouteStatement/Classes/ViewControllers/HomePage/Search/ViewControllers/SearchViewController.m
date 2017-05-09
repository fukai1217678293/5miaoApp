//
//  SearchViewController.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/16.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchApiManager.h"
#import "HotwordSearchApiManager.h"
#import "RecommandSearchApiManager.h"
#import "SearchReformer.h"
#import "SearchResultVC.h"
#import "SearchRecommandVC.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,VTAPIManagerCallBackDelegate,VTAPIManagerParamSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchVC;
//@property (nonatomic, strong) NSMutableArray *searchResults;//接收数据源结果
@property (nonatomic, strong) NSMutableArray *hotwordArray;

@property (nonatomic, strong) HotwordSearchApiManager *hotwordApiManager;
@property (nonatomic, strong) RecommandSearchApiManager *recommandApiManager;
@property (nonatomic, strong) NSString *searchText;

@end

@implementation SearchViewController

#pragma mark -- life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.showNormalBackButtonItem = YES;
    self.navigationItem.titleView = self.searchVC.searchBar;
    [self.view addSubview:self.tableView];
    [self.hotwordApiManager loadData];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
}
- (void)leftItemClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.hotwordApiManager) {
        
        return @{};
    }
    else if (manager == self.recommandApiManager) {
        
        return @{@"q":self.searchText};
    }
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    
    SearchReformer * reformer = [[SearchReformer alloc] init];
    
    id formerData = [manager fetchDataWithReformer:reformer];
    
    
    if (manager == self.hotwordApiManager) {
        
        self.hotwordArray = [formerData mutableCopy];
        
        [self.tableView reloadData];
    }
    else if (manager == self.recommandApiManager) {
        
//        self.searchResults = [formerData mutableCopy];
        SearchRecommandVC *resultVC = (SearchRecommandVC *)self.searchVC.searchResultsController;
        [resultVC tableViewReloadDataWithSource:[formerData mutableCopy]];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    
    
    if (manager == self.hotwordApiManager) {
        
        
    }
    else if (manager == self.recommandApiManager) {
        
    }
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 取每个section对应的数组
    return self.hotwordArray.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    if (indexPath.row == 0) {
        UILabel * titleLab = [cell viewWithTag:1001];
        if (!titleLab) {
            titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
            titleLab.backgroundColor = [UIColor whiteColor];
            titleLab.textAlignment = NSTextAlignmentCenter;
            titleLab.font = [UIFont systemFontOfSize:16];
            titleLab.tag = 1001;
            titleLab.text = @"\n\n热门搜索";
            titleLab.numberOfLines = 0;
            [cell addSubview:titleLab];
        }
        titleLab.textColor = cell.textLabel.textColor;
    }
    else {
        if (self.hotwordArray.count) {
            NSDictionary * data = self.hotwordArray[indexPath.row-1];
            cell.textLabel.text = data[@"name"];
            cell.imageView.image = [UIImage imageNamed:@"icon_xiaosousuo.png"];
        }
    }
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}
#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 50;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchResultVC * searchResultVC = [[SearchResultVC alloc] init];
//    if (self.searchVC.active) {
//        //针对如果没有输入的情况下
//        if (self.searchResults.count) {
//            NSDictionary * result = self.searchResults[indexPath.row];
//            searchResultVC.searchKeyword = result[@"title"];
//        }
//        else {
//            NSDictionary * data = self.hotwordArray[indexPath.row-1];
//            NSString * keyword = data[@"name"];
//            self.searchVC.searchBar.text = keyword;
//            searchResultVC.searchKeyword = keyword;
//        }
//        [self.searchVC.searchBar endEditing:YES];
//    }
//    else {
//        if (indexPath.row == 0) {
//            return;
//        }
//      
//    }
    NSDictionary * data = self.hotwordArray[indexPath.row-1];
    NSString * keyword = data[@"name"];
    self.searchVC.searchBar.text = keyword;
    searchResultVC.searchKeyword = keyword;
    [self.navigationController pushViewController:searchResultVC animated:YES];
}
#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{                     // called when keyboard search button pressed
    if (searchBar.text.length) {
        [searchBar endEditing:YES];
        SearchResultVC * searchResultVC = [[SearchResultVC alloc] init];
        searchResultVC.searchKeyword = searchBar.text;
        [self.navigationController pushViewController:searchResultVC animated:YES];
    }
    else {//with no content input
        
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}
#pragma mark -- UISearchControllerDelegate
// 搜索界面将要出现
- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"将要  开始  搜索时触发的方法");
}

// 搜索界面将要消失
-(void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"将要  取消  搜索时触发的方法");
    self.searchText = @"";
    [self.recommandApiManager cancelAllRequest];
}

-(void)didDismissSearchController:(UISearchController *)searchController
{
//    [self.searchResults removeAllObjects];
    [self.tableView reloadData];
}
#pragma mark -- 搜索方法
// 搜索时触发的方法
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    self.searchText = [self.searchVC.searchBar text];
    if (_searchText.length) {
        [self.recommandApiManager cancelAllRequest];
        [self.recommandApiManager loadData];
    }
}

#pragma mark -- setter

#pragma mark -- getter 

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;
}

- (UISearchController *)searchVC {
    if (!_searchVC) {
        WEAKSELF;
        SearchRecommandVC * resultVC = [[SearchRecommandVC alloc] init];
        resultVC.presentationViewController = self;
        resultVC.selectedRowHandle = ^(NSString *title) {
            [weakSelf.searchVC.searchBar endEditing:YES];
            weakSelf.searchVC.searchBar.text = title;
        };
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        _searchVC.searchResultsUpdater = self;
        _searchVC.delegate  = self;
        _searchVC.searchBar.frame = CGRectMake(-20, 0, SCREEN_WIDTH-100, 44);
        _searchVC.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchVC.searchBar.placeholder = @"请输入关键词";
        _searchVC.searchBar.delegate = self;
        _searchVC.dimsBackgroundDuringPresentation = NO;
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        self.definesPresentationContext = YES;
    }
    return _searchVC;
}

- (HotwordSearchApiManager *)hotwordApiManager {
    if (!_hotwordApiManager) {
        _hotwordApiManager = [[HotwordSearchApiManager alloc] init];
        _hotwordApiManager.delegate = self;
        _hotwordApiManager.paramsourceDelegate = self;
    }
    
    return _hotwordApiManager;
}
- (RecommandSearchApiManager *)recommandApiManager {
    
    if (!_recommandApiManager) {
        
        _recommandApiManager = [[RecommandSearchApiManager alloc] init];
        _recommandApiManager.delegate = self;
        _recommandApiManager.paramsourceDelegate = self;
    }
    
    return _recommandApiManager;
}

- (NSMutableArray *)hotwordArray {
    
    if (!_hotwordArray) {
        
        _hotwordArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _hotwordArray;
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
