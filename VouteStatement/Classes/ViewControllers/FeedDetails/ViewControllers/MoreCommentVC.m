//
//  MoreCommentVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/6.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "MoreCommentVC.h"
//#import "CommentModel.h"
//#import "MoreCommentApiManager.h"
//#import "FeedDetailTableViewCell.h"
//#import "VTURLResponse.h"
//#import "FeedDetailReformer.h"
//#import "VouteHeaderView.h"
#import "AddCommentVC.h"
#import "NewestCommentVC.h"
#import "HotestCommentVC.h"
#import "CommentMenuView.h"
@interface MoreCommentVC ()<UIScrollViewDelegate>
//@property (nonatomic,strong)UITableView     *commentTableView;
@property (nonatomic,strong)UIView          *footerView;
@property (nonatomic,strong)CommentMenuView *menuView;
//@property (nonatomic,strong)NSMutableArray  *hotComments;
//@property (nonatomic,strong)NSMutableArray  *latestComments;
//@property (nonatomic,strong)NSMutableArray  *latestPosComments;
//@property (nonatomic,strong)NSMutableArray  *latestNegComments;
//@property (nonatomic,strong)NSMutableArray  *hotestPosComments;
//@property (nonatomic,strong)NSMutableArray  *hotestNegComments;
//@property (nonatomic,strong)MoreCommentApiManager *apimanager;
//@property (nonatomic,assign)VouteHeaderViewState vouteHeaderState;
//@property (nonatomic,strong)NSString        *lastAnchor;
@property (nonatomic,strong)UIScrollView    *mainScroll;
@end

@implementation MoreCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = [NSString stringWithFormat:@"评论(%d)",self.totalCommentCount];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.view.backgroundColor = UIRGBColor(241, 241, 241, 1.0f);
//    [self.view addSubview:self.commentTableView];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.mainScroll];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark -- action method
- (void)toComment {
    AddCommentVC *addcommentVC = [[AddCommentVC alloc] init];
    addcommentVC.fid = self.fid;
    addcommentVC.side= self.side;
    [self.navigationController pushViewController:addcommentVC animated:YES];
}
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    self.menuView.currentSelectIndex = targetContentOffset->x/SCREEN_WIDTH;
    
}


#pragma mark -- getter
- (CommentMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[CommentMenuView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
        WEAKSELF;
        _menuView.menuItemClick = ^(NSInteger index){
            [weakSelf.mainScroll setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
        };
    }
    return _menuView;
}
- (UIScrollView *)mainScroll {
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104-60)];
        _mainScroll.backgroundColor = [UIColor whiteColor];
        _mainScroll.delegate = self;
        _mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-104-60);
        _mainScroll.showsHorizontalScrollIndicator = NO;
        _mainScroll.showsVerticalScrollIndicator = NO;
        _mainScroll.bounces = NO;
        _mainScroll.pagingEnabled = YES;
        _mainScroll.scrollEnabled = NO;
        UIViewController * childVC;
        for (int i = 0; i < 2; i ++) {
            if (i == 0) {
                childVC = [[NewestCommentVC alloc] init];
            }
            else {
                childVC = [[HotestCommentVC alloc] init];
            }
            childVC.view.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, _mainScroll.height);
            [_mainScroll addSubview:childVC.view];
            [self addChildViewController:childVC];
        }
    }
    return _mainScroll;
}
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
        _footerView.backgroundColor = [UIColor clearColor];
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 40);
        commentButton.layer.cornerRadius = 5.0f;
        commentButton.layer.masksToBounds= YES;
        commentButton.backgroundColor = UIRGBColor(246, 26, 84, 1);
        [commentButton setTitle:@"立即评论" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [commentButton addTarget:self action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:commentButton];
    }
    return _footerView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
