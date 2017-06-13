//
//  ResetPwdVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "ResetPwdVC.h"
#import "VTTextFeild.h"
#import "PostTagReformer.h"
//#import "PostTagApiManager.h"
#import "MessageApiManager.h"
#import "ResetPwdApiManager.h"
#import "JSRSA.h"

static NSTimeInterval const reGetVerifyCodeCountdownTimeInterval = 1.0f;

@interface ResetPwdVC ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)VTTextFeild *verifyCodeTextFeildView;
@property (nonatomic,strong)VTTextFeild *pwdVTTextFeildView;
@property (nonatomic,strong)UIButton    *registButton;
@property (nonatomic,strong)UIButton    *regetVerifyCodeButton;
@property (nonatomic,strong)CALayer     *splitLine;
@property (nonatomic,strong)NSTimer     *countdownTimer;
@property (nonatomic,assign)NSInteger countdown;
//@property (nonatomic,strong)PostTagApiManager   *registPostTagApiManager;
//@property (nonatomic,strong)PostTagApiManager   *messagePostTagApiManager;
@property (nonatomic,strong)MessageApiManager   *messageApiManager;
@property (nonatomic,strong)ResetPwdApiManager  *resetPwdApiManager;
@property (nonatomic,strong)NSString            *registUXTag;
@property (nonatomic,strong)NSString            *messageUXTag;
@property (nonatomic,strong)MBProgressHUD       *registHUD;

@end

@implementation ResetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"重置密码";
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.verifyCodeTextFeildView];
    [self.view addSubview:self.pwdVTTextFeildView];
    [self.view addSubview:self.registButton];
    self.countdown = 60;
}
#pragma mark -- Action mehtod
- (void)registClick {
    if ([NSString isBlankString:self.verifyCodeTextFeildView.textField.text]) {
        [self showMessage:@"请输入短信验证码,如未收到,请稍后再试" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.pwdVTTextFeildView.textField.text]) {
        [self showMessage:@"请输入新密码" inView:self.view];
        return;
    }
    self.registHUD = [self showHUDLoadingWithMessage:@"重置密码中.." inView:self.view];
    [self.resetPwdApiManager loadData];
}
- (void)regetVerifyCodeClick:(UIButton *)sender{
    [self.messageApiManager loadData];
}
- (void)countdownScheduledTimer {
    self.countdown --;
}
#pragma mark --VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
//    if (self.messagePostTagApiManager == manager) {
//        return @{};
//    }
//    else if (self.registPostTagApiManager == manager) {
//        return @{};
//    }
//    else
    
    if (self.messageApiManager == manager) {
        
        NSDictionary * param =  @{@"phone":self.phoneNumber,
                                  @"stype":@"valid"};
        return param;
    }
    else {
        
        NSString* encWithPubKey = [JSRSA encryptString:self.pwdVTTextFeildView.textField.text publicKey:RSA_PUBLIC_KEY];
        return @{@"phone":self.phoneNumber,
                 @"sms":self.verifyCodeTextFeildView.textField.text,
                 @"password":encWithPubKey};
    }
}
#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
//    if (manager == self.messagePostTagApiManager) {
//        PostTagReformer * reformer = [[PostTagReformer alloc] init];
//        self.messageUXTag = [manager fetchDataWithReformer:reformer];
//    }
//    else if (manager == self.registPostTagApiManager){
//        PostTagReformer * reformer = [[PostTagReformer alloc] init];
//        self.registUXTag = [manager fetchDataWithReformer:reformer];
//    }
//    else
    
    if (manager == self.messageApiManager) {
        //重置时间
        self.countdown = 60;
    }
    else  {
        [self hiddenHUD:self.registHUD];
        [self showMessage:@"重置成功,请重新登录" inView:self.navigationController.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    if (self.registHUD) {
        [self hiddenHUD:self.registHUD];
    }
    [self showMessage:manager.errorMessage inView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- setter
- (void)setCountdown:(NSInteger)countdown {
    if (countdown == 0) {
        [_countdownTimer invalidate];
        _countdownTimer = nil;
        [_regetVerifyCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_regetVerifyCodeButton setEnabled:YES];
    }
    else {
        if (!_countdownTimer) {
            [self.countdownTimer fire];
        }
        [_regetVerifyCodeButton setTitle:[NSString stringWithFormat:@"重新获取%lds",(long)countdown] forState:UIControlStateNormal];
        [_regetVerifyCodeButton setEnabled:NO];
    }
    _countdown = countdown;
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
- (VTTextFeild *)verifyCodeTextFeildView {
    if (!_verifyCodeTextFeildView) {
        _verifyCodeTextFeildView = [[VTTextFeild alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0f, _logoImageView.bottom+50, 300, 35) icon:[UIImage imageNamed:@"icon_yanzhengma.png"] placeholder:@"请输入验证码"];
        _verifyCodeTextFeildView.textField.keyboardType = UIKeyboardTypeNumberPad;
        CGRect frame =  _verifyCodeTextFeildView.textField.frame;
        frame.size.width = frame.size.width/2.0f;
        _verifyCodeTextFeildView.textField.frame = frame;
        [_verifyCodeTextFeildView addSubview:self.regetVerifyCodeButton];
        [_verifyCodeTextFeildView.layer addSublayer:self.splitLine];
    }
    return _verifyCodeTextFeildView;
}
- (VTTextFeild *)pwdVTTextFeildView {
    
    if (!_pwdVTTextFeildView) {
        
        _pwdVTTextFeildView = [[VTTextFeild alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0f, _verifyCodeTextFeildView.bottom+10, 300, 35)icon:[UIImage imageNamed:@"icon_mima.png"] placeholder:@"输入新密码"];
        _pwdVTTextFeildView.textField.secureTextEntry = YES;
    }
    return _pwdVTTextFeildView;
}
- (UIButton *)registButton {
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.frame = CGRectMake(_pwdVTTextFeildView.left-5, _pwdVTTextFeildView.bottom+15, _pwdVTTextFeildView.width+10, 40);
        _registButton.backgroundColor = UIRGBColor(245, 45, 84, 1.0f);
        [_registButton setTitle:@"提交" forState:UIControlStateNormal];
        [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _registButton.layer.cornerRadius = 5.0f;
        _registButton.layer.masksToBounds = YES;
        [_registButton addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _registButton;
}
- (UIButton *)regetVerifyCodeButton {
    if (!_regetVerifyCodeButton) {
        _regetVerifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _regetVerifyCodeButton.frame = CGRectMake(_verifyCodeTextFeildView.textField.right+2, _verifyCodeTextFeildView.textField.top, _verifyCodeTextFeildView.textField.width-2, _verifyCodeTextFeildView.textField.height);
        _regetVerifyCodeButton.backgroundColor = [UIColor clearColor];
        [_regetVerifyCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_regetVerifyCodeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _regetVerifyCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_regetVerifyCodeButton addTarget:self action:@selector(regetVerifyCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        _regetVerifyCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _regetVerifyCodeButton.enabled = NO;
    }
    return  _regetVerifyCodeButton;
}
- (CALayer *)splitLine {
    if (!_splitLine) {
        _splitLine = [[CALayer alloc] init];
        _splitLine.backgroundColor =[UIColor lightGrayColor].CGColor;
        _splitLine.frame = CGRectMake(_verifyCodeTextFeildView.textField.right, _verifyCodeTextFeildView.textField.top, 1, _verifyCodeTextFeildView.textField.height-5);
    }
    return _splitLine;
}
- (NSTimer *)countdownTimer {
    if (!_countdownTimer) {
        _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:reGetVerifyCodeCountdownTimeInterval target:self selector:@selector(countdownScheduledTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_countdownTimer forMode:NSRunLoopCommonModes];
    }
    return _countdownTimer;
}
- (ResetPwdApiManager *)resetPwdApiManager {
    if (!_resetPwdApiManager) {
        _resetPwdApiManager = [[ResetPwdApiManager alloc] init];
        _resetPwdApiManager.delegate = self;
        _resetPwdApiManager.paramsourceDelegate = self;
    }
    return _resetPwdApiManager;
}
- (MessageApiManager *)messageApiManager {
    if (!_messageApiManager) {
        _messageApiManager = [[MessageApiManager alloc] init];
        _messageApiManager.delegate = self;
        _messageApiManager.paramsourceDelegate = self;
    }
    return _messageApiManager;
}
//- (PostTagApiManager *)registPostTagApiManager {
//    if (!_registPostTagApiManager) {
//        _registPostTagApiManager = [[PostTagApiManager alloc] init];
//        _registPostTagApiManager.delegate = self;
//        _registPostTagApiManager.paramsourceDelegate = self;
//    }
//    return _registPostTagApiManager;
//}
//- (PostTagApiManager *)messagePostTagApiManager {
//    if (!_messagePostTagApiManager) {
//        _messagePostTagApiManager = [[PostTagApiManager alloc] init];
//        _messagePostTagApiManager.delegate = self;
//        _messagePostTagApiManager.paramsourceDelegate = self;
//    }
//    return _messagePostTagApiManager;
//}
@end
