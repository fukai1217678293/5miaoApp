//
//  SettingInformationVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/25.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "SettingInformationVC.h"
#import "ImagePickerManager.h"
#import "SettingNicknameVC.h"
#import "SettingSignatureVC.h"
#import "UpdateUserInfoApiManager.h"
#import "PostTagReformer.h"
#import "PostTagApiManager.h"
#import "UploadImageApiManager.h"
#import "UploadImageReformer.h"
#import "UserCenterVC.h"
#import "UIImage+Extention.h"
static NSInteger kHeaderButtonTag = 2001;
@interface SettingInformationVC ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource,UITableViewDelegate,UITableViewDataSource> {
    
    NSArray         * _titleArray;
}
@property (nonatomic,strong)UITableView *infoTableView;
//当前选择图片
@property (nonatomic,strong)UIImage *selectedImage;
//更新信息api
@property (nonatomic,strong)UpdateUserInfoApiManager *updateApiManager;
//post tag api
//@property (nonatomic,strong)PostTagApiManager *postTagApiManager;
//图片上传api
@property (nonatomic,strong)UploadImageApiManager *uploadImageApiManager;
//图片上传地址
@property (nonatomic,strong)NSString *uploadURLString;
//post tag
@property (nonatomic,strong)NSString *postTag;

@property (nonatomic,strong)MBProgressHUD       *uploadImageHUD;
@property (nonatomic,strong)MBProgressHUD       *updateInfoHUD;
@property (nonatomic,strong)ImagePickerManager  *imagePickerManager;
@end

@implementation SettingInformationVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.infoTableView];
    [self configNavigationItem];
    [self commonVariable];
}
- (void)configNavigationItem {
    
    self.showNormalBackButtonItem = YES;
    self.navigationItem.title = @"修改个人信息";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    UIButton * customView = self.commonRightBarbuttonItem.customView;
    [customView setTitle:@"保存" forState:UIControlStateNormal];
    [customView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    customView.titleLabel.font = [UIFont systemFontOfSize:13];
    [customView addTarget:self action:@selector(saveInformation) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = self.commonRightBarbuttonItem;
}
- (void)commonVariable {
    
    _titleArray = @[@"头像",@"昵称"];
    _nickName = [VTAppContext shareInstance].username;
    self.headerImageURLString = [VTAppContext shareInstance].headerImageUrl;
   // _signature = [VTAppContext shareInstance].signature;
}
#pragma mark -- action Method
- (void)saveInformation {
    
    UITableViewCell * nicknameCell = [_infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel     * nicknameDetailLab = [nicknameCell viewWithTag:101];
    NSString    * nickname = nicknameDetailLab.text ? nicknameDetailLab.text : @"";
    if ([NSString isBlankString:nickname]) {
        [self showMessage:@"昵称不能为空" inView:self.view];
        return;
    }
    
    if (self.selectedImage) {
        self.uploadImageHUD = [self showHUDLoadingWithMessage:@"上传头像中..." inView:self.view];
        [self.uploadImageApiManager loadData];
    }
    else {
        self.updateInfoHUD = [self showHUDLoadingWithMessage:@"更新中.." inView:self.view];
         [self.updateApiManager loadData];
    }
}
- (void)headerClicked:(UIButton *)sender {
    [self.imagePickerManager actionSheetShowInView:self.view];
    WEAKSELF;
    self.imagePickerManager.didSelectedImagehandle = ^(UIImage *image) {
        UITableViewCell * cell = [weakSelf.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIButton * headerButton = [cell viewWithTag:kHeaderButtonTag];
        UIImage * fixImage = [image fixOrientation];
        [headerButton setImage:fixImage forState:UIControlStateNormal];
        weakSelf.selectedImage =fixImage;
    };
}
#pragma mark -- VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    
    if (manager == self.updateApiManager) {
        
        UITableViewCell * nicknameCell = [_infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UILabel     * nicknameDetailLab = [nicknameCell viewWithTag:101];
        NSString    * nickname = nicknameDetailLab.text ? nicknameDetailLab.text : @"";
        
        UITableViewCell * signatureCell = [_infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UILabel     * signatureDetailLab = [signatureCell viewWithTag:102];
//        NSString    * signature = signatureDetailLab.text ? signatureDetailLab.text : @"";
        self.uploadURLString = self.uploadURLString ? self.uploadURLString :[VTAppContext shareInstance].headerImageUrl;
        return @{@"username":nickname,
                 @"avatar":self.uploadURLString,
                 @"uxtag":self.postTag};
    }
    else if (manager == self.uploadImageApiManager) {
        
        return @{@"image":self.selectedImage,
                 @"wsfile":@"",
                 @"ftype":@"avatar"};
    }
    return @{};
}
#pragma mark -- VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
//    if (manager == self.postTagApiManager) {
//        PostTagReformer * refomer = [[PostTagReformer alloc] init];
//        self.postTag = [manager fetchDataWithReformer:refomer];
//        [self.updateApiManager loadData];
//    }
//    else
    
    if (manager == self.uploadImageApiManager) {
        UploadImageReformer * reformer = [[UploadImageReformer alloc] init];
        self.uploadURLString =[manager fetchDataWithReformer:reformer];
        [self hiddenHUD:self.uploadImageHUD];
        self.updateInfoHUD = [self showHUDLoadingWithMessage:@"更新中.." inView:self.view];
        [self.updateApiManager loadData];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:UserCenterViewControllerWillUpdateNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    if (manager == self.uploadImageApiManager) {
        [self hiddenHUD:self.uploadImageHUD];
    }
    if (!self.updateInfoHUD) {
        [self hiddenHUD:self.updateInfoHUD];
    }
    [self showMessage:manager.errorMessage inView:self.navigationController.view];
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.textColor = UIRGBColor(90, 90, 90, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:14.5f];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        UIButton * headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.frame = CGRectMake(SCREEN_WIDTH-100, 7.5f, 60, 60);
        headerBtn.layer.cornerRadius = 30.0f;
        headerBtn.layer.masksToBounds = YES;
        headerBtn.backgroundColor = [UIColor whiteColor];
        headerBtn.tag = kHeaderButtonTag;
        [headerBtn sd_setImageWithURL:[NSURL URLWithString:_headerImageURLString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"header_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                
            }
        }];
        [headerBtn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:headerBtn];
    }
    else {
        UILabel * detailLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0,SCREEN_WIDTH-130, cell.height)];
        detailLab.backgroundColor = [UIColor whiteColor];
        detailLab.textAlignment = NSTextAlignmentRight;
        detailLab.textColor = UIRGBColor(138, 138, 138, 1.0f);
        detailLab.font = [UIFont systemFontOfSize:16.5f];
        detailLab.text =  _nickName  ;
        detailLab.tag = indexPath.row + 100;
        [cell addSubview:detailLab];
    }
    return cell;
    
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 75;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        
        SettingNicknameVC * nicknameVC = [[SettingNicknameVC alloc] init];
        [self.navigationController pushViewController:nicknameVC animated:YES];
    }
    else if (indexPath.row == 2) {
        
        SettingSignatureVC * signatureVC = [[SettingSignatureVC alloc] init];
        [self.navigationController pushViewController:signatureVC animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark -- setter
- (void)setNickName:(NSString *)nickName {
    
    UITableViewCell * cell = [_infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel * detailLab = [cell viewWithTag:101];
    detailLab.text = nickName;
    _nickName = nickName;
}
- (void)setSignature:(NSString *)signature {
    
    UITableViewCell * cell = [_infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UILabel * detailLab = [cell viewWithTag:102];
    detailLab.text = signature;
  //  _signature = signature;
    
}
#pragma mark -- getter
- (UITableView *)infoTableView {
    
    if (!_infoTableView) {
        
        _infoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _infoTableView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.tableFooterView = [UIView new];
        [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _infoTableView;
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
- (UpdateUserInfoApiManager *)updateApiManager {
    
    if (!_updateApiManager) {
        
        _updateApiManager = [[UpdateUserInfoApiManager alloc] init];
        _updateApiManager.delegate = self;
        _updateApiManager.paramsourceDelegate= self;
    }
    return _updateApiManager;
}
- (UploadImageApiManager *)uploadImageApiManager {
    
    if (!_uploadImageApiManager) {
        
        _uploadImageApiManager = [[UploadImageApiManager alloc] init];
        _uploadImageApiManager.delegate = self;
        _uploadImageApiManager.paramsourceDelegate= self;
    }
    return _uploadImageApiManager;
}
- (ImagePickerManager *)imagePickerManager {
    if (!_imagePickerManager) {
        _imagePickerManager = [[ImagePickerManager alloc] initWithPresentedViewController:self.navigationController cropRect:CGRectMake((SCREEN_WIDTH-200)/2.0f, (SCREEN_HEIGHT-200)/2.0f, 200, 200)];
//        _imagePickerManager.minPhotoWidthSelectable = 600.0f;
//        _imagePickerManager.minPhotoHeightSelectable = 338.0f;
    }
    return _imagePickerManager;
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
