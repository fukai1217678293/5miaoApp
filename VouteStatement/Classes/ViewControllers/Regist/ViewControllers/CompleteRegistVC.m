//
//  CompleteRegistVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/18.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CompleteRegistVC.h"
#import "VTTextFeild.h"
#import "MessageApiManager.h"
#import "PostTagReformer.h"
#import "PostTagApiManager.h"
#import "RegistApiManager.h"
#import "RSA.h"
#import "JSRSA.h"
#import "LoginReformer.h"
#import "RegistProtocolVC.h"
#import "UMMobClick/MobClick.h"

static NSTimeInterval const reGetVerifyCodeCountdownTimeInterval = 1.0f;

@interface CompleteRegistVC ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)VTTextFeild *verifyCodeTextFeildView;
@property (nonatomic,strong)VTTextFeild *nameVTTextFeildView;
@property (nonatomic,strong)VTTextFeild *pwdVTTextFeildView;
@property (nonatomic,strong)UIButton    *registButton;
@property (nonatomic,strong)UIButton    *regetVerifyCodeButton;
@property (nonatomic,strong)UIButton    *agreeProtocolButton;
@property (nonatomic,strong)UIButton    *registerProtocolButton;
@property (nonatomic,strong)CALayer     *splitLine;
@property (nonatomic,strong)NSTimer     *countdownTimer;
@property (nonatomic,assign)NSInteger countdown;
//@property (nonatomic,strong)PostTagApiManager   *registPostTagApiManager;
//@property (nonatomic,strong)PostTagApiManager   *messagePostTagApiManager;
@property (nonatomic,strong)MessageApiManager   *messageApiManager;
@property (nonatomic,strong)RegistApiManager    *registApiManager;
@property (nonatomic,strong)NSString            *registUXTag;
@property (nonatomic,strong)NSString            *messageUXTag;
@property (nonatomic,strong)MBProgressHUD       *registHUD;

@end

@implementation CompleteRegistVC

- (void)viewDidLoad {

    [super viewDidLoad];
    self.showNormalBackButtonItem = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.navigationItem.title = @"注册";
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.verifyCodeTextFeildView];
    [self.view addSubview:self.nameVTTextFeildView];
    [self.view addSubview:self.pwdVTTextFeildView];
    [self.view addSubview:self.registButton];
    [self.view addSubview:self.agreeProtocolButton];
    [self.view addSubview:self.registerProtocolButton];
    self.countdown = 60;
}

#pragma mark -- Action mehtod
- (void)registClick {
    if ([NSString isBlankString:self.verifyCodeTextFeildView.textField.text]) {
        [self showMessage:@"请输入短信验证码,如未收到,请稍后再试" inView:self.view];
        return;
    }
    if ([NSString isBlankString:self.pwdVTTextFeildView.textField.text]) {
        [self showMessage:@"请输入密码" inView:self.view];
        return;
    }
    if (!self.agreeProtocolButton.selected) {
        [self showMessage:@"请阅读后勾选同意用户协议" inView:self.view];
        return;
    }
    self.registHUD = [self showHUDLoadingWithMessage:@"注册中.." inView:self.view];
    [self.registApiManager loadData];
}
- (void)regetVerifyCodeClick:(UIButton *)sender{
    [self.messageApiManager loadData];
}
- (void)checkBoxProtocolAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (void)protocolClickedAction:(UIButton *)sender {
    RegistProtocolVC *protocolVC = [RegistProtocolVC new];
    [self.navigationController pushViewController:protocolVC animated:YES];
}
- (void)countdownScheduledTimer {
    self.countdown --;
}
#pragma mark --VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (self.messageApiManager == manager) {
        
        NSDictionary * param =  @{@"phone":self.phoneNumber,
                                  @"stype":@"reg"};
        return param;
    }
    else {
        NSString* encWithPubKey = [JSRSA encryptString:self.pwdVTTextFeildView.textField.text publicKey:RSA_PUBLIC_KEY];
        if ([NSString isBlankString:self.nameVTTextFeildView.textField.text]) {
            return @{@"phone":self.phoneNumber,
                     @"sms":self.verifyCodeTextFeildView.textField.text,
                     @"password":encWithPubKey};
        } else {
            return @{@"phone":self.phoneNumber,
                     @"sms":self.verifyCodeTextFeildView.textField.text,
                     @"username":self.nameVTTextFeildView.textField.text,
                     @"password":encWithPubKey};
        }
    }
}
#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if (manager == self.messageApiManager) {
        //重置时间
        self.countdown = 60;
    }
    else  {
        [MobClick event:@"register_finish"];
        LoginReformer *loginReformer = [[LoginReformer alloc] init];
        NSDictionary *data = [manager fetchDataWithReformer:loginReformer];
        [VTAppContext shareInstance].token = data[@"token"];
        [VTAppContext shareInstance].token_type = data[@"token_type"];
        [self hiddenHUD:self.registHUD];
        [self.navigationController dismissViewControllerAnimated:YES completion:self.completionhandle];
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
- (VTTextFeild *)nameVTTextFeildView {
    
    if (!_nameVTTextFeildView) {
        _nameVTTextFeildView = [[VTTextFeild alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0f, _verifyCodeTextFeildView.bottom+10, 300, 35) icon:[UIImage imageNamed:@"icon_shouji.png"] placeholder:@"输入用户名(可选)"];
    }
    return _nameVTTextFeildView;
}
- (VTTextFeild *)pwdVTTextFeildView {
    if (!_pwdVTTextFeildView) {
        _pwdVTTextFeildView = [[VTTextFeild alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0f, _nameVTTextFeildView.bottom+10, 300, 35) icon:[UIImage imageNamed:@"icon_mima.png"] placeholder:@"输入密码"];
        _pwdVTTextFeildView.textField.secureTextEntry = YES;
    }
    return _pwdVTTextFeildView;
}
- (UIButton *)registButton {
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registButton.frame = CGRectMake(_pwdVTTextFeildView.left-5, _pwdVTTextFeildView.bottom+45, _pwdVTTextFeildView.width+10, 40);
        _registButton.backgroundColor = UIRGBColor(245, 45, 84, 1.0f);
        [_registButton setTitle:@"注册" forState:UIControlStateNormal];
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
- (UIButton *)agreeProtocolButton {
    if (!_agreeProtocolButton) {
        _agreeProtocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeProtocolButton.frame = CGRectMake(_pwdVTTextFeildView.left, _pwdVTTextFeildView.bottom+10, 20, 20);
        _agreeProtocolButton.backgroundColor = [UIColor clearColor];
        [_agreeProtocolButton setTitleColor: UIRGBColor(245, 45, 84, 1.0f) forState:UIControlStateNormal];
        _agreeProtocolButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_agreeProtocolButton addTarget:self action:@selector(checkBoxProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeProtocolButton setImage:[UIImage imageNamed:@"un_selected.png"] forState:UIControlStateNormal];
        [_agreeProtocolButton setImage:[UIImage imageNamed:@"icon_protocol_sel.png"] forState:UIControlStateSelected];
        _agreeProtocolButton.selected = YES;
    }
    return  _agreeProtocolButton;
}
- (UIButton *)registerProtocolButton {
    if (!_registerProtocolButton) {
        _registerProtocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerProtocolButton.frame = CGRectMake(_agreeProtocolButton.right+5, _pwdVTTextFeildView.bottom+10, 150, 20);
        _registerProtocolButton.backgroundColor = [UIColor clearColor];
        [_registerProtocolButton setTitleColor: UIRGBColor(245, 45, 84, 1.0f) forState:UIControlStateNormal];
        [_registerProtocolButton setTitle:@"《用户注册协议》" forState:UIControlStateNormal];
        _registerProtocolButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registerProtocolButton addTarget:self action:@selector(protocolClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_registerProtocolButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return  _registerProtocolButton;
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
- (RegistApiManager *)registApiManager {
    if (!_registApiManager) {
        _registApiManager = [[RegistApiManager alloc] init];
        _registApiManager.delegate = self;
        _registApiManager.paramsourceDelegate = self;
    }
    return _registApiManager;
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
