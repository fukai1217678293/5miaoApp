//
//  SearchRecommandVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/3/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "SearchRecommandVC.h"
#import "SearchResultVC.h"

@interface SearchRecommandVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray  *dataSource;

@end

@implementation SearchRecommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}
- (void)tableViewReloadDataWithSource:(NSArray *)results {
    self.dataSource = [results mutableCopy];
    [self.tableView reloadData];
}
#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 取每个section对应的数组
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    UILabel * titleLab = [cell viewWithTag:1001];
    
    if (titleLab) {
        
        [titleLab removeFromSuperview];
    }
    if (self.dataSource.count) {
        NSDictionary * result = self.dataSource[indexPath.row];
        cell.textLabel.text = result[@"title"];
        cell.imageView.image = [UIImage imageNamed:@"icon_xiaosousuo.png"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}
#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultVC * searchResultVC = [[SearchResultVC alloc] init];
    NSDictionary * result = self.dataSource[indexPath.row];
    searchResultVC.searchKeyword = result[@"title"];
    if (self.selectedRowHandle) {
        self.selectedRowHandle(result[@"title"]);
    }
    [self.presentationViewController.navigationController pushViewController:searchResultVC animated:YES];
}

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
