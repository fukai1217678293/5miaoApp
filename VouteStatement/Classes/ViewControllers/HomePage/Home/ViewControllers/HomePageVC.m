//
//  HomePageVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "HomePageVC.h"
#import "HomeMenuItemView.h"
#import "QZFindVC.h"
#import "LocalVC.h"
#import "SearchViewController.h"
#import "LoginViewController.h"

@interface HomePageVC ()<UIScrollViewDelegate> {

}

@property (nonatomic,strong)HomeMenuItemView *menuView;

@property (nonatomic,strong)UIScrollView *mainScroll;

@property (nonatomic,strong)UIButton *searchBtn;

@end

@implementation HomePageVC

#pragma mark -- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.mainScroll];
//    [self.view addSubview:self.searchBtn];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark -- action
- (void)searchAction {
//
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- ScrollView delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.mainScroll) {
        self.menuView.currentSelectIndex = targetContentOffset->x/SCREEN_WIDTH;
    }
}

#pragma mark -- setter && getter
- (HomeMenuItemView *)menuView {
    if (!_menuView) {
        _menuView = [[HomeMenuItemView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
        _menuView.backgroundColor = [UIColor whiteColor];
        WEAKSELF;
        _menuView.menuItemClick = ^(NSInteger index){
            [weakSelf.mainScroll setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
        };
    }
    return _menuView;
}

- (UIScrollView *)mainScroll {
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
        _mainScroll.backgroundColor = [UIColor whiteColor];
        _mainScroll.delegate = self;
        _mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-64-49);
        _mainScroll.showsHorizontalScrollIndicator = NO;
        _mainScroll.showsVerticalScrollIndicator = NO;
        _mainScroll.bounces = YES;
        _mainScroll.pagingEnabled = YES;
        UIViewController * childVC;
        for (int i = 0; i < 2; i ++) {
            if (i == 0) {
                childVC = [[QZFindVC alloc] init];
            }
            else {
                childVC = [[LocalVC alloc] init];
            }
            
            childVC.view.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, _mainScroll.height);
            [_mainScroll addSubview:childVC.view];
            [self addChildViewController:childVC];
        }
    }
    return _mainScroll;
}

- (UIButton *)searchBtn {
    
    if (!_searchBtn) {
        
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-49-60, 60, 60);
        _searchBtn.backgroundColor = [UIColor clearColor];
        [_searchBtn setImage:[UIImage imageNamed:@"icon_sousuo.png"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchBtn;
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
