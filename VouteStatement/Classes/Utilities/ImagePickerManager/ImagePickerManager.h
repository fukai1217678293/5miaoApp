//
//  ImagePickerManager.h
//  VouteStatement
//
//  Created by 付凯 on 2017/1/21.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "TZImagePickerController.h"

typedef void (^DidSelectImagehandle)(UIImage *image);

@interface ImagePickerManager : NSObject<UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,copy)DidSelectImagehandle didSelectedImagehandle;

@property (nonatomic,assign)CGFloat minPhotoWidthSelectable;

@property (nonatomic,assign)CGFloat minPhotoHeightSelectable;

- (instancetype)initWithPresentedViewController:(UIViewController *)controller;

- (instancetype)initWithPresentedViewController:(UIViewController *)controller showEditCrop:(BOOL)crop;

- (instancetype)initWithPresentedViewController:(UIViewController *)controller cropRect:(CGRect)cropRect;

- (void)actionSheetShowInView:(UIView *)view;

@end
