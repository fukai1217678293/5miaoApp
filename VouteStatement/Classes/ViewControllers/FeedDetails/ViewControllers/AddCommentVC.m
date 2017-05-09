//
//  AddCommentVC.m
//  VouteStatement
//
//  Created by 付凯 on 2017/2/6.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "AddCommentVC.h"
#import "ImagePickerManager.h"
#import "AddCommentApiManager.h"
//#import "PostTagApiManager.h"
#import "UploadImageApiManager.h"
#import "UploadImageReformer.h"
#import "PostTagReformer.h"
#import "VTTextView.h"

NSString * const AddCommentViewControllerDidSubmitNewCommentNotificationName = @"AddCommentViewControllerDidSubmitNewCommentNotificationName";

@interface AddCommentVC ()<VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)UIBarButtonItem         *rightBarButtonItem;
@property (nonatomic,strong)AddCommentApiManager    *addCommentApi;
//@property (nonatomic,strong)PostTagApiManager       *postTagApi;
@property (nonatomic,strong)UploadImageApiManager   *uploadImageApi;
@property (nonatomic,strong)NSString                *postTag;
@property (nonatomic,strong)NSString                *uploadURLString;
@property (nonatomic,strong)UIImage                 *selectImage;
@property (nonatomic,strong)VTTextView              *vtTextView;
@property (nonatomic,strong)UIView                  *bgView;

@property (nonatomic,strong)MBProgressHUD           *imageUploadHUD;
@property (nonatomic,strong)MBProgressHUD           *commentUploadHUD;
@property (nonatomic,strong)ImagePickerManager      *imagePickerManager;

@end

@implementation AddCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNormalBackButtonItem = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.bgView];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.navigationItem.title = @"发评论";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.view.backgroundColor = UIRGBColor(241, 241, 241, 1.0f);
}
#pragma mark -- action method 
- (void)photoClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.imagePickerManager actionSheetShowInView:self.view];
    WEAKSELF;
    __weak typeof(sender) weakSender = sender;
    self.imagePickerManager.didSelectedImagehandle = ^(UIImage *image){
        NSData * imageData = UIImageJPEGRepresentation(image, 0.3);
        weakSelf.selectImage = [UIImage imageWithData:imageData];
        [weakSender setImage:image forState:UIControlStateNormal];
    };
}
- (void)addComment {
    if (self.vtTextView.text.length < 4) {
        [self showMessage:@"评论需要4~500字" inView:self.view];
        return;
    }
    if (self.selectImage) {//是否上传图片
        self.imageUploadHUD = [self showHUDLoadingWithMessage:@"上传图片中.." inView:self.view];
        [self.uploadImageApi loadData];
    }
    else {
        
        self.commentUploadHUD = [self showHUDLoadingWithMessage:@"提交评论中.." inView:self.view];
        [self.addCommentApi loadData];
    }
}
#pragma mark --VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    if (manager == self.uploadImageApi) {
        return @{@"image":self.selectImage,
                 @"wsfile":@"",
                 @"ftype":@"comment"};
    }
    else if (manager == self.addCommentApi) {
        /*fid:用户投票的feed id，
         content:评论内容，
         side:用户选择正方还是反方， 0 反方， 1 正方 
         */
        if ([NSString isBlankString:self.uploadURLString]) {
            return @{@"fid":self.fid,
                     @"content":self.vtTextView.text,
                     @"side":self.side,
                     @"uxtag":self.postTag,
                     @"pic":@""};
        }
        else {
            return @{@"fid":self.fid,
                     @"content":self.vtTextView.text,
                     @"side":self.side,
                     @"uxtag":self.postTag,
                     @"pic":self.uploadURLString};
        }
    }
    return @{};
}
#pragma mark --VTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    if (manager == self.uploadImageApi) {
        
        UploadImageReformer * reformer = [[UploadImageReformer alloc] init];
        self.uploadURLString = [manager fetchDataWithReformer:reformer];
        if (self.imageUploadHUD) {
            [self hiddenHUD:self.imageUploadHUD];
        }
        self.commentUploadHUD = [self showHUDLoadingWithMessage:@"提交评论中.." inView:self.view];
        [self.addCommentApi loadData];
    }
    else {
        [self hiddenHUD:self.commentUploadHUD];
        //通知刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:AddCommentViewControllerDidSubmitNewCommentNotificationName object:nil userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    
    if (manager == self.uploadImageApi) {
        if (self.imageUploadHUD) {
            [self hiddenHUD:self.imageUploadHUD];
        }
    }
    else {
        [self hiddenHUD:self.commentUploadHUD];
    }
    [self showMessage:manager.errorMessage inView:self.view];
}
#pragma mark --getter
//- (PostTagApiManager *)postTagApi {
//    if (!_postTagApi) {
//        _postTagApi = [[PostTagApiManager alloc] init];
//        _postTagApi.delegate = self;
//        _postTagApi.paramsourceDelegate = self;
//    }
//    return _postTagApi;
//}
- (UploadImageApiManager *)uploadImageApi {
    if (!_uploadImageApi) {
        _uploadImageApi = [[UploadImageApiManager alloc] init];
        _uploadImageApi.delegate = self;
        _uploadImageApi.paramsourceDelegate = self;
    }
    return _uploadImageApi;
}
- (AddCommentApiManager *)addCommentApi {
    if (!_addCommentApi) {
        _addCommentApi = [[AddCommentApiManager alloc] initWithFid:self.fid];
        _addCommentApi.delegate = self;
        _addCommentApi.paramsourceDelegate = self;
    }
    return _addCommentApi;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 260)];
        [_bgView addSubview:self.vtTextView];
        _bgView.backgroundColor = [UIColor whiteColor];
        
//        UIButton * takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        takePhotoButton.frame = CGRectMake(10, _vtTextView.bottom, 100, 100);
//        takePhotoButton.backgroundColor = [UIColor clearColor];
//        takePhotoButton.tag = 1001;
//        [takePhotoButton addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
//        UIImage * img = [UIImage imageNamed:@"icon_tianjiatupiani.png"];
//        [takePhotoButton setImage:img forState:UIControlStateNormal];
//        [_bgView addSubview:takePhotoButton];
    }
    return _bgView;
}
- (VTTextView *)vtTextView {
    if (!_vtTextView) {
        _vtTextView = [[VTTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
        _vtTextView.placeholder = @"请输入不少于4字的评论";
        _vtTextView.limitLength = 500;
    }
    return _vtTextView;
}
- (UIBarButtonItem *)rightBarButtonItem {
    
    if (!_rightBarButtonItem ) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _rightBarButtonItem;
}
- (ImagePickerManager *)imagePickerManager {
    if (!_imagePickerManager) {
        _imagePickerManager = [[ImagePickerManager alloc] initWithPresentedViewController:self.navigationController];
        _imagePickerManager.minPhotoWidthSelectable = 0.0f;
        _imagePickerManager.minPhotoHeightSelectable = 0.0f;
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
