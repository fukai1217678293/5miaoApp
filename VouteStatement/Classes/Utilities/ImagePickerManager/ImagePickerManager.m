//
//  ImagePickerManager.m
//  VouteStatement
//
//  Created by 付凯 on 2017/1/21.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "ImagePickerManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TZImageManager.h"

@interface ImagePickerManager ()<UIActionSheetDelegate>

@property (nonatomic,strong)UIViewController          *presentViewController;
@property (nonatomic,strong)UIImagePickerController     *imagePickerVc;
@property (nonatomic,assign)BOOL              showCrop;
@property (nonatomic,assign)CGRect            cropRect;
@property (nonatomic,strong)UIActionSheet           *sheet;

@end

@implementation ImagePickerManager


- (instancetype)initWithPresentedViewController:(BaseViewController *)controller {
    if (self = [super init]) {
        self.presentViewController = controller;
        self.showCrop = NO;
    }
    return self;
}
- (instancetype)initWithPresentedViewController:(UIViewController *)controller showEditCrop:(BOOL)crop {
    if (self = [super init]) {
        self.presentViewController = controller;
        self.showCrop = crop;
    }
    return self;
}
- (instancetype)initWithPresentedViewController:(BaseViewController *)controller cropRect:(CGRect)cropRect {
    if (self = [super init]) {
        self.presentViewController = controller;
        self.showCrop = YES;
        self.cropRect = cropRect;
    }
    return self;
}
#pragma mark - Public Method
- (void)actionSheetShowInView:(UIView *)view {
    [self.sheet showInView:view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}
#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        WEAKSELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [weakSelf takePhoto];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self.presentViewController presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}
#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
//    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
//    if (self.maxCountTF.text.integerValue > 1) {
        // 1.设置目前已经选中的图片数组
//        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//    }
//    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch.isOn; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
//    imagePickerVc.allowPickingVideo = self.allowPickingVideoSwitch.isOn;
//    imagePickerVc.allowPickingImage = self.allowPickingImageSwitch.isOn;
//    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
//    imagePickerVc.allowPickingGif = self.allowPickingGifSwitch.isOn;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
//
    // imagePickerVc.minImagesCount = 3;
     imagePickerVc.alwaysEnableDoneBtn = YES;
    
    
     imagePickerVc.minPhotoWidthSelectable = self.minPhotoWidthSelectable;
     imagePickerVc.minPhotoHeightSelectable = self.minPhotoHeightSelectable;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
//    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.showCrop;
    if (self.showCrop) {
        if (CGRectEqualToRect(_cropRect, CGRectZero)) {
            imagePickerVc.cropRect = CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH*9/16.0f)/2.0f, SCREEN_WIDTH, SCREEN_WIDTH*9/16.0f);
        }
        else {
            imagePickerVc.cropRect = _cropRect;
        }
    }

//    imagePickerVc.needCircleCrop = self.needCircleCropSwitch.isOn;
//    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    WEAKSELF;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (weakSelf.didSelectedImagehandle) {
            weakSelf.didSelectedImagehandle([photos firstObject]);
        }
    }];
    
    [self.presentViewController presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WEAKSELF;
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (weakSelf.showCrop) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                if (weakSelf.didSelectedImagehandle) {
                                    weakSelf.didSelectedImagehandle(cropImage);
                                }
                            }];
                            if (CGRectEqualToRect(weakSelf.cropRect, CGRectZero)) {
                                imagePicker.cropRect = CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH*9/16.0f)/2.0f, SCREEN_WIDTH, SCREEN_WIDTH*9/16.0f);
                            }
                            else {
                                imagePicker.cropRect = weakSelf.cropRect;
                            }
                            imagePicker.minPhotoWidthSelectable = weakSelf.minPhotoWidthSelectable;
                            imagePicker.minPhotoHeightSelectable = weakSelf.minPhotoHeightSelectable;
                            [self.presentViewController presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            if (weakSelf.didSelectedImagehandle) {
                                weakSelf.didSelectedImagehandle(image);
                            }
                        }
                    }];
                }];
            }
        }];
    }
    
//    // 获取媒体类型
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    // 判断是图片或视频
//    if ([mediaType isEqualToString:(NSString*)kUTTypeImage])
//    {
//        // 获得用户编辑后的图像
//        UIImage *orginalImage = [info objectForKey:UIImagePickerControllerEditedImage];
//        // NSData *imgData = UIImageJPEGRepresentation(orginalImage, 1.0);
//        //dto.data = imgData;
////        [self uploadImage:orginalImage];
//        
//        if (self.didSelectedImagehandle) {
//    
//            self.didSelectedImagehandle(orginalImage);
//        }
//    }
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [picker dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}


- (void)uploadImage:(UIImage *)image{
    
    if (!image) {
        return;
    }
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.presentViewController.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.presentViewController.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
- (UIActionSheet *)sheet {
    if (!_sheet) {
        _sheet= [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self
                                   cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    }
    return _sheet;
}


@end
