//
//  HHCamera.m
//  HHSelectPhoto
//
//  Created by Michael on 2018/9/11.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "HHNative.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <SCM-Swift.h>
@interface HHNative()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end
@implementation HHNative
#pragma mark
+ (nonnull instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

#pragma mark 打开相册
- (void)openPhotoWithController:(UIViewController *)vc {
    // 从相册中选取
    //iOS13之后 下面代码必须得在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        controller.navigationBar.translucent = NO;
        [vc presentViewController:controller
                         animated:YES
                       completion:nil];
    });
}

#pragma mark 打开摄像头
- (void)openCameraWithController:(UIViewController *)vc {
    //iOS13之后 下面代码必须得在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.allowsEditing  = NO;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSMutableArray *mediaTypes = [NSMutableArray array];

        //拍照片
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        //可以拍视频
        [mediaTypes addObject:(NSString *)kUTTypeMovie];
        imagePickerController.videoMaximumDuration = 60;
        
        imagePickerController.mediaTypes= mediaTypes;
        imagePickerController.delegate = self;
        [vc presentViewController:imagePickerController animated:YES completion:nil];
    });
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //相册退出
    [picker dismissViewControllerAnimated:YES completion:nil];
    //
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            [HHImageManager savePhotoWithImage:photo location:nil completionHandler:^(PHAsset * _Nullable asset, NSError * _Nullable error) {
                if (self.resultAsset) {
                    self.resultAsset(asset, error);
                }
            }];
        }
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
//        if (videoUrl) {
//            [[HHPhotoManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
//                if (!error) {
//                    [self addPHAsset:asset];
//                }
//            }];
//            self.location = nil;
//        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        //TO DO
    }];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //对相册的导航条修改
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&((UIImagePickerController *)navigationController).sourceType ==UIImagePickerControllerSourceTypePhotoLibrary) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}



#pragma mark ------------   camera utility  ------------

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}


- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
@end
