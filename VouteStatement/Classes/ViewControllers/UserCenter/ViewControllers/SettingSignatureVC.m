//
//  SettingSignatureVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "SettingSignatureVC.h"
#import "SettingInformationVC.h"
#import "VTTextView.h"

@interface SettingSignatureVC ()

@property (nonatomic,strong)VTTextView *signatureTextView;

@end

@implementation SettingSignatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationItem];
    [self.view addSubview:self.signatureTextView];
    self.view.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)configNavigationItem {
    
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"个性签名";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    UIButton * customView = self.commonRightBarbuttonItem.customView;
    [customView setTitle:@"确定" forState:UIControlStateNormal];
    [customView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    customView.titleLabel.font = [UIFont systemFontOfSize:13];
    [customView addTarget:self action:@selector(saveSignature) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = self.commonRightBarbuttonItem;
}
#pragma mark -- action method
- (void)saveSignature {
    
    if (self.signatureTextView.text.length <= 0) {
        
        return;
    }
//    SettingInformationVC *infoVC = (SettingInformationVC *)self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:self]-1];
    //infoVC.signature = self.signatureTextView.text;
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -- getter
- (VTTextView *)signatureTextView {
    
    if (!_signatureTextView) {
        
        _signatureTextView = [[VTTextView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 260)];
        _signatureTextView.backgroundColor = [UIColor whiteColor];
        SettingInformationVC *infoVC = (SettingInformationVC *)self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:self]-1];
        _signatureTextView.placeholder = @"请输入您的个性签名..";
      //  _signatureTextView.text = infoVC.signature;
        _signatureTextView.limitLength = 500;
        
        
    }
    return _signatureTextView;
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
