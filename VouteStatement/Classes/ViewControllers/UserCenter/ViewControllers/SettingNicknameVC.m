//
//  SettingNicknameVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "SettingNicknameVC.h"
#import "VTTextView.h"
#import "SettingInformationVC.h"

@interface SettingNicknameVC ()

@property (nonatomic,strong)VTTextView *nicknameTextView;

@end

@implementation SettingNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationItem];
    [self.view addSubview:self.nicknameTextView];
    self.view.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)configNavigationItem {
    
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"昵称";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    UIButton * customView = self.commonRightBarbuttonItem.customView;
    [customView setTitle:@"确定" forState:UIControlStateNormal];
    [customView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    customView.titleLabel.font = [UIFont systemFontOfSize:13];
    [customView addTarget:self action:@selector(saveNickname) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = self.commonRightBarbuttonItem;
}
#pragma mark -- action method
- (void)saveNickname {
    
    if (self.nicknameTextView.text.length <= 0) {
        
        return;
    }
    SettingInformationVC *infoVC = (SettingInformationVC *)self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:self]-1];
    infoVC.nickName = self.nicknameTextView.text;
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -- getter
- (VTTextView *)nicknameTextView {
    
    if (!_nicknameTextView) {
        
        _nicknameTextView = [[VTTextView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 260)];
        _nicknameTextView.backgroundColor = [UIColor whiteColor];
        SettingInformationVC *infoVC = (SettingInformationVC *)self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:self]-1];
        _nicknameTextView.placeholder = @"请输入昵称..";
        _nicknameTextView.text = infoVC.nickName;
        _nicknameTextView.limitLength = 20;

        
    }
    return _nicknameTextView;
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
