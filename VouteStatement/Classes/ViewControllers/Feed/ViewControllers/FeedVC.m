////
////  FeedVC.m
////  VouteStatement
////
////  Created by 付凯 on 2017/1/14.
////  Copyright © 2017年 韫安. All rights reserved.
////
//
//#import "FeedVC.h"
//#import "VTTextView.h"
//#import "ImagePickerManager.h"
//#import "AddFeedApiManager.h"
//#import "UploadImageReformer.h"
//#import "UploadImageApiManager.h"
//#import "VTLocationManager.h"
//#import "PostTagApiManager.h"
//#import "PostTagReformer.h"
//#import "UIImage+Extention.h"
//#import "FeedDetailsVC.h"
//#import "VTURLResponse.h"
//@interface FeedVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>
//
//@property (nonatomic,strong)UIBarButtonItem         *rightBarButtonItem;
//@property (nonatomic,strong)UICollectionView        *feedCollectionView;
//@property (nonatomic,strong)AddFeedApiManager       *addfeedApiManager;
//@property (nonatomic,strong)UploadImageApiManager   *uploadImageApiManager;
//@property (nonatomic,strong)PostTagApiManager       *postTagApiManager;
//@property (nonatomic,strong)UIImage                 *selectedImage;
//@property (nonatomic,assign)CLLocationCoordinate2D userLocation;
//@property (nonatomic,strong)NSString                *uploadURLString;
//@property (nonatomic,strong)NSString                *uxtag;
//@property (nonatomic,strong)MBProgressHUD           *uploadImageHUD;
//@property (nonatomic,strong)MBProgressHUD           *addFeedHUD;
//@property (nonatomic,strong)ImagePickerManager      *imagePickerManager;
//@property (nonatomic,assign)BOOL                     isLocated;
//
//@end
//
//@implementation FeedVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.navigationItem.title = @"创建投票话题";
//    self.showNormalBackButtonItem = YES;
//    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
//    WEAKSELF;
//    self.backActionhandle = ^(){
//        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
//    };
//    [self.view addSubview:self.feedCollectionView];
//}
//- (void)startLocation {
//    __weak FeedVC * weakSelf = self;
//    [[VTLocationManager shareInstance] locationWithSuccessCallback:^(CLLocationCoordinate2D coor) {
//        if (weakSelf.isLocated) {
//            return ;
//        }
//        if (!weakSelf.isLocated) {
//            weakSelf.userLocation = coor;
//            [weakSelf.uploadImageApiManager loadData];
//            weakSelf.isLocated = YES;
//        }
//
//    } failCallback:^(NSString *error) {
//        if (!weakSelf.uploadImageHUD.isHidden) {
//            [weakSelf hiddenHUD:weakSelf.uploadImageHUD];
//        }
//        if (!weakSelf.addFeedHUD.isHidden) {
//            [weakSelf hiddenHUD:weakSelf.addFeedHUD];
//        }
//        [weakSelf showMessage:error inView:weakSelf.view];
//        NSLog(@"%@",error);
//    }];
//}
//
//#pragma mark -- Action method
//- (void)releaseFeed {
//    
//    [self.view endEditing:YES];
//    if (!self.selectedImage) {
//        [self showMessage:@"请选择一张图片" inView:self.view];
//        return;
//    }
//    if (self.selectedImage.size.width < 600) {
//        [self showMessage:@"您选择的图片过小,请重新选择" inView:self.view];
//        return;
//    }
//    UICollectionViewCell * item_0_cell = [self.feedCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//    VTTextView * titleTextView = [item_0_cell viewWithTag:1000];
//    if ([NSString isBlankString:titleTextView.text]) {
//        [self showMessage:@"请输入标题" inView:self.view];
//        return;
//    }
//    if (titleTextView.text.length < 5) {
//        [self showMessage:@"您输入的标题过短" inView:self.view];
//        return;
//    }
//    self.uploadImageHUD = [self showHUDLoadingWithMessage:@"正在上传图片.." inView:self.view];
//    if (self.isLocated) {
//        [self.uploadImageApiManager loadData];
//    }
//    else {
//        [self startLocation];
//    }
//}
//- (void)photoClick:(UIButton *)sender {
//    [self.view endEditing:YES];
//    [self.imagePickerManager actionSheetShowInView:self.view];
//    WEAKSELF;
//    __weak typeof(sender) weakSender = sender;
//    self.imagePickerManager.didSelectedImagehandle = ^(UIImage *image){
//        NSData * imageData = UIImageJPEGRepresentation([image fixOrientation], 0.3);
//        weakSelf.selectedImage = [UIImage imageWithData:imageData];
//        [weakSender setImage:image forState:UIControlStateNormal];
//    };
//}
//#pragma mark -- VTAPIManagerParamSource
//- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
//    if (manager == self.uploadImageApiManager) {
//        return @{@"image":self.selectedImage,
//                 @"wsfile":@"",
//                 @"ftype":@"feed"};
//    }
//    else if (manager == self.postTagApiManager) {
//        return @{};
//    }
//
//    UICollectionViewCell * item_0_cell = [self.feedCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//    VTTextView * titleTextView = [item_0_cell viewWithTag:1000];
//
//    UICollectionViewCell * item_1_cell = [self.feedCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
//    VTTextView * descriptionTextView = [item_1_cell viewWithTag:1002];
//    NSString *title = titleTextView.text;
//    NSString *description = descriptionTextView.text;
//    return @{@"title":title,
//             @"description":description,
//             @"pic":self.uploadURLString,
//             @"lat":@(self.userLocation.latitude),
//             @"lng":@(self.userLocation.longitude),
//             @"uxtag":self.uxtag};
//}
//#pragma mark -- VTAPIManagerCallBackDelegate
//- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
//    
//    if (manager == self.uploadImageApiManager) {
//        UploadImageReformer * reformer = [[UploadImageReformer alloc] init];
//        self.uploadURLString =  [manager fetchDataWithReformer:reformer];
////        [self startLocation];
//        [self hiddenHUD: self.uploadImageHUD];
//        self.addFeedHUD = [self showHUDLoadingWithMessage:@"正在发表" inView:self.view];
//        [self.postTagApiManager loadData];
//    }
//    else if (manager == self.postTagApiManager) {
//        PostTagReformer * reformer = [[PostTagReformer alloc] init];
//        self.uxtag = [manager fetchDataWithReformer:reformer];
//        [self.addfeedApiManager loadData];
//    }
//    else {
//        [self hiddenHUD:self.addFeedHUD];
//        [self showMessage:@"发表成功" inView:self.navigationController.view];
//        NSDictionary * responseDict = manager.response.content;
//        NSDictionary * dataDict     = responseDict[@"data"];
//        NSString     * fid          = dataDict[@"fid"];
//        [self.navigationController dismissViewControllerAnimated:YES completion:^{
//            KeyWindow
//            UITabBarController * rootVC = (UITabBarController *)window.rootViewController;
//            UINavigationController  *selectedNav = [rootVC selectedViewController];
//            FeedDetailsVC *detailVC =[[FeedDetailsVC alloc] init];
//            detailVC.fid = fid;
//            detailVC.hidesBottomBarWhenPushed = YES;
//            [selectedNav pushViewController:detailVC animated:YES];
//        }];
//    }
//}
//- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
//    if (manager == self.uploadImageApiManager) {
//        [self hiddenHUD:self.uploadImageHUD];
//    }
//    else {
//        [self hiddenHUD:self.addFeedHUD];
//    }
//    [self showMessage:manager.errorMessage inView:self.view];
//}
//#pragma mark -- UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    
//    return 3;
//}
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//    if (indexPath.item == 1) { //拍照按钮
//        UIButton * photoButton = [cell viewWithTag:1001];
//        if (!photoButton) {
//            photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            photoButton.frame = CGRectMake(10, 15, 100, 100);
//            photoButton.backgroundColor = [UIColor clearColor];
//            [photoButton setImage:[UIImage imageNamed:@"icon_tianjiatupiani.png"] forState:UIControlStateNormal];
//            photoButton.tag = 1001;
//            [photoButton addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
//            [cell addSubview:photoButton];
//        }
//    }
//    else {
//        VTTextView *vtTextView = [cell viewWithTag:1000+indexPath.item];
//        if (!vtTextView) {
//                vtTextView = [[VTTextView alloc] initWithFrame:cell.bounds];
//                if (indexPath.item == 0) {
//                    vtTextView.placeholder = @"请输入标题...";
//                    vtTextView.limitLength = 50;
//                }else {
//                    vtTextView.placeholder = @"简介(可不填)...";
//                    vtTextView.limitLength = LONG_MAX;
//                }
//                vtTextView.tag = 1000+indexPath.item;
//            [cell addSubview:vtTextView];
//        }
//    }
//    return cell;
//}
//#pragma mark -- UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item == 0) { return CGSizeMake(SCREEN_WIDTH, 80) ;}
//    if (indexPath.item == 1) { return CGSizeMake(SCREEN_WIDTH, 130);}
//    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-230); //保证全屏铺满
//}
//
//#pragma mark -- getter
//- (UIBarButtonItem *)rightBarButtonItem {
//    if (!_rightBarButtonItem ) {
//        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"发布" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [btn setBackgroundColor:[UIColor clearColor]];
//        btn.titleLabel.font = [UIFont systemFontOfSize:13];
//        btn.frame = CGRectMake(0, 0, 30, 30);
//        [btn addTarget:self action:@selector(releaseFeed) forControlEvents:UIControlEventTouchUpInside];
//        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    }
//    return _rightBarButtonItem;
//}
//- (UICollectionView *)feedCollectionView {
//    if (!_feedCollectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing   = 10.0f;
//        layout.estimatedItemSize    = CGSizeMake(SCREEN_WIDTH, 80);
//        _feedCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//        _feedCollectionView.delegate    = self;
//        _feedCollectionView.dataSource  = self;
//        _feedCollectionView.backgroundColor = UIRGBColor(242, 242, 242, 1.0f);
//        [_feedCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    }
//    return _feedCollectionView;
//}
//- (AddFeedApiManager *)addfeedApiManager {
//    if (!_addfeedApiManager) {
//        _addfeedApiManager = [[AddFeedApiManager alloc] init];
//        _addfeedApiManager.delegate = self;
//        _addfeedApiManager.paramsourceDelegate = self;
//    }
//    return _addfeedApiManager;
//}
//- (UploadImageApiManager *)uploadImageApiManager {
//    if (!_uploadImageApiManager) {
//        _uploadImageApiManager = [[UploadImageApiManager alloc] init];
//        _uploadImageApiManager.delegate = self;
//        _uploadImageApiManager.paramsourceDelegate = self;
//    }
//    return _uploadImageApiManager;
//}
//- (PostTagApiManager *)postTagApiManager {
//    if (!_postTagApiManager) {
//        _postTagApiManager = [[PostTagApiManager alloc] init];
//        _postTagApiManager.delegate = self;
//        _postTagApiManager.paramsourceDelegate = self;
//    }
//    return _postTagApiManager;
//}
//- (ImagePickerManager *)imagePickerManager {
//    if (!_imagePickerManager) {
//        _imagePickerManager = [[ImagePickerManager alloc] initWithPresentedViewController:self.navigationController showEditCrop:YES];
//        _imagePickerManager.minPhotoWidthSelectable = 600.0f;
//        _imagePickerManager.minPhotoHeightSelectable = 338.0f;
//    }
//    return _imagePickerManager;
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//@end
