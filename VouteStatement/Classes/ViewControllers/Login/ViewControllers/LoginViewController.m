//
//  LoginViewController.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/17.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "LoginViewController.h"
#import "VTTextFeild.h"
#import "RegistViewController.h"
#import "JSRSA.h"
#import "VTUserTagHelper.h"
#import "LoginApiManager.h"
#import "PostTagReformer.h"
#import "LoginReformer.h"
#import "ForgetPwdVC.h"
#import "UMMobClick/MobClick.h"
#import "JPUSHService.h"
#import "JPushHelper.h"
@interface LoginViewController ()<VTAPIManagerParamSource,VTAPIManagerCallBackDelegate>

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)VTTextFeild *userNameVTTextFeildView;
@property (nonatomic,strong)VTTextFeild *pwdVTTextFeildView;
@property (nonatomic,strong)UIBarButtonItem *rightBarButtonItem;
@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UIButton *fogetPwdButton;
//@property (nonatomic,strong)PostTagApiManager *postTagApiManager;
@property (nonatomic,strong)LoginApiManager *loginApiManager;
@property (nonatomic,strong)NSString *uxPostTag;
@property (nonatomic,strong)MBProgressHUD *loginHUD;

@end

@implementation LoginViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.showNormalBackButtonItem   = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.navigationItem.title       = @"登录";
//    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.userNameVTTextFeildView];
    [self.view addSubview:self.pwdVTTextFeildView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.fogetPwdButton];
}
#pragma mark -- acion method
- (void)loginClick {
    
    if ([NSString isBlankString:self.userNameVTTextFeildView.textField.text]) {
        [self showMessage:@"用户名不能为空" inView:self.view];
        return;
    }
    else if ([NSString isValidateMobile:self.userNameVTTextFeildView.textField.text]) {
        [self showMessage:@"您的手机号码有误" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.pwdVTTextFeildView.textField.text]) {
        [self showMessage:@"请输入密码" inView:self.view];
        return;
    }
    self.loginHUD = [self showHUDLoadingWithMessage:@"登录中" inView:self.view];
    [self.loginApiManager loadData];
}
- (void)goToRegist {
    [MobClick event:@"register_start"];
    RegistViewController * registVC = [[RegistViewController alloc] init];
    registVC.completionhandle = self.completionhandle;
    [self.navigationController pushViewController:registVC animated:YES];
}
- (void)fogetClick {
    ForgetPwdVC * forgetPwdVC = [[ForgetPwdVC alloc] init];
    forgetPwdVC.completionhandle = self.completionhandle;
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    NSString * encryptPwd = [JSRSA encryptString:self.pwdVTTextFeildView.textField.text publicKey:RSA_PUBLIC_KEY];
    return @{@"phone"   :self.userNameVTTextFeildView.textField.text,
             @"password":encryptPwd};
}
#pragma mark -- VTAPIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    [MobClick event:@"login_finish"];
    LoginReformer * loginReformer = [[LoginReformer alloc] init];
    NSDictionary * loginValue = [manager fetchDataWithReformer:loginReformer];
    [VTAppContext shareInstance].token = loginValue[@"token"];
    [VTAppContext shareInstance].token_type = loginValue[@"token_type"];
    [VTAppContext shareInstance].hash_name = loginValue[@"hash"];
    DismissCompletionhandle completion = [self.completionhandle copy];
    [self hiddenHUD:self.loginHUD];
    [[JPushHelper shareInstance] setAlias:[VTAppContext shareInstance].hash_name];
    [[VTUserTagHelper sharedHelper] startBindNewTags];
    [self.navigationController dismissViewControllerAnimated:YES completion:completion];
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    [self hiddenHUD:self.loginHUD];
    [self showMessage:manager.errorMessage inView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- getter
- (UIImageView *)logoImageView {
    
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_5s_logo.png"]];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.frame = CGRectMake((SCREEN_WIDTH-95)/2.0f, 100, 95, 95);
        _logoImageView.backgroundColor = [UIColor clearColor];
    }
    return _logoImageView;
}
- (VTTextFeild *)userNameVTTextFeildView {
    if (!_userNameVTTextFeildView) {
        _userNameVTTextFeildView = [[VTTextFeild alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0f, _logoImageView.bottom+50, 300, 35) icon:[UIImage imageNamed:@"icon_shouji.png"] placeholder:@"请输入手机号"];
        _userNameVTTextFeildView.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _userNameVTTextFeildView;
}
- (VTTextFeild *)pwdVTTextFeildView {
    
    if (!_pwdVTTextFeildView) {
        
        _pwdVTTextFeildView = [[VTTextFeild alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0f, _userNameVTTextFeildView.bottom+10, 300, 35) icon:[UIImage imageNamed:@"icon_mima"] placeholder:@"输入密码"];
        _pwdVTTextFeildView.textField.secureTextEntry = YES;
    }
    return _pwdVTTextFeildView;
}
- (UIBarButtonItem *)rightBarButtonItem {
    
    if (!_rightBarButtonItem ) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"注册" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(goToRegist) forControlEvents:UIControlEventTouchUpInside];
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _rightBarButtonItem;
}
- (UIButton *)loginButton {
    
    if (!_loginButton) {
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(_pwdVTTextFeildView.left-5, _pwdVTTextFeildView.bottom+15, _pwdVTTextFeildView.width+10, 40);
        _loginButton.backgroundColor = UIRGBColor(245, 45, 84, 1.0f);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _loginButton.layer.cornerRadius = 5.0f;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return  _loginButton;
}
- (UIButton *)fogetPwdButton {
    
    if (!_fogetPwdButton) {
        
        _fogetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fogetPwdButton.frame = CGRectMake(_loginButton.right-110, _loginButton.bottom+20, 110, 20);
        _fogetPwdButton.backgroundColor = [UIColor clearColor];
        [_fogetPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_fogetPwdButton setTitleColor:UIRGBColor(245, 45, 84, 1.0f) forState:UIControlStateNormal];
        _fogetPwdButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _fogetPwdButton.layer.cornerRadius = 5.0f;
        [_fogetPwdButton addTarget:self action:@selector(fogetClick) forControlEvents:UIControlEventTouchUpInside];
        _fogetPwdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
    }
    return  _fogetPwdButton;
    
}
//- (PostTagApiManager *)postTagApiManager {
//    
//    if (!_postTagApiManager) {
//        
//        _postTagApiManager = [[PostTagApiManager alloc] init];
//        _postTagApiManager.delegate = self;
//        _postTagApiManager.paramsourceDelegate = self;
//    }
//    return _postTagApiManager;
//}
- (LoginApiManager *)loginApiManager {
    
    if (!_loginApiManager) {
        
        _loginApiManager = [[LoginApiManager alloc] init];
        _loginApiManager.delegate = self;
        _loginApiManager.paramsourceDelegate = self;
    }
    return _loginApiManager;
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
