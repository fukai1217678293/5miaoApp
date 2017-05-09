//
//  ForgetPwdVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/14.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "ForgetPwdVC.h"
#import "VTTextFeild.h"
//#import "PostTagApiManager.h"
#import "MessageApiManager.h"
#import "PostTagReformer.h"
#import "ResetPwdVC.h"

@interface ForgetPwdVC ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)VTTextFeild *phoneVTTextFeildView;
@property (nonatomic,strong)UIButton    *nextStepButton;
//@property (nonatomic,strong)PostTagApiManager *postTagApiManager;
@property (nonatomic,strong)MessageApiManager *messageApiManager;
@property (nonatomic,strong)NSString *ustag;
@end

@implementation ForgetPwdVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"重置密码";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.phoneVTTextFeildView];
    [self.view addSubview:self.nextStepButton];
    
}
#pragma mark -- Action method
- (void)nextStepClick {
    
    if ([NSString isBlankString:self.phoneVTTextFeildView.textField.text]) {
        [self showMessage:@"请输入手机号" inView:self.view];
        return;
    }
    if ([NSString isValidateMobile:self.phoneVTTextFeildView.textField.text]) {
        [self showMessage:@"您输入的手机号有误" inView:self.view];
        return;
    }
    [self.messageApiManager loadData];
}
#pragma mark --VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    
    if (manager == self.messageApiManager) {
        
        NSDictionary * param =  @{@"phone":_phoneVTTextFeildView.textField.text,
                                  @"stype":@"valid"};
        
        return param;
    }
    return @{};
}
#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    ResetPwdVC * resetPwdVC = [[ResetPwdVC alloc] init];
    resetPwdVC.phoneNumber  = self.phoneVTTextFeildView.textField.text;
    resetPwdVC.completionhandle = self.completionhandle;
    [self.navigationController pushViewController:resetPwdVC animated:YES];
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    
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
//        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
//        _logoImageView.frame = CGRectMake((SCREEN_WIDTH-100)/2.0f, 100, 100, 35);
//        _logoImageView.backgroundColor = [UIColor redColor];
    }
    return _logoImageView;
}
- (VTTextFeild *)phoneVTTextFeildView {
    
    if (!_phoneVTTextFeildView) {
        
        _phoneVTTextFeildView = [[VTTextFeild alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0f, _logoImageView.bottom+50, 300, 35) icon:[UIImage imageNamed:@"icon_shouji.png"] placeholder:@"输入手机号"];
        _phoneVTTextFeildView.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneVTTextFeildView;
}
- (UIButton *)nextStepButton {
    
    if (!_nextStepButton) {
        
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepButton.frame = CGRectMake(_phoneVTTextFeildView.left-5, _phoneVTTextFeildView.bottom+15, _phoneVTTextFeildView.width+10, 40);
        _nextStepButton.backgroundColor = UIRGBColor(245, 45, 84, 1.0f);
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _nextStepButton.layer.cornerRadius = 5.0f;
        _nextStepButton.layer.masksToBounds = YES;
        [_nextStepButton addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return  _nextStepButton;
}

//- (PostTagApiManager *)postTagApiManager {
//    
//    if (!_postTagApiManager) {
//        
//        _postTagApiManager = [[PostTagApiManager alloc] init];
//        _postTagApiManager.delegate = self;
//        _postTagApiManager.paramsourceDelegate = self;
//        
//    }
//    return _postTagApiManager;
//}
- (MessageApiManager *)messageApiManager {
    
    if (!_messageApiManager) {
        
        _messageApiManager = [[MessageApiManager alloc] init];
        _messageApiManager.delegate = self;
        _messageApiManager.paramsourceDelegate= self;
    }
    return _messageApiManager;
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
