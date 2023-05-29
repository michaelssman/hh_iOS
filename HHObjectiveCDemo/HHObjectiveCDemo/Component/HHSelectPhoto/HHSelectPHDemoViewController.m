//
//  ViewController.m
//  HHSelectPhoto
//
//  Created by Michael on 2018/8/7.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "HHSelectPHDemoViewController.h"
#import "HHNative.h"
#import <SCM-Swift.h>
@interface HHSelectPHDemoViewController ()
@property (nonatomic, strong)UIImageView *imgV;

@end

@implementation HHSelectPHDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    button0.backgroundColor = [UIColor whiteColor];
    button0.layer.masksToBounds = YES;
    button0.layer.cornerRadius = 20.0;
    button0.layer.borderColor = [UIColor blueColor].CGColor;
    button0.layer.borderWidth = 1.0;
    [button0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button0 setTitle:@"选择相册" forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(phTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button0];
    button0.frame = CGRectMake(100, 150, 100, 50);
    button0.backgroundColor = [UIColor purpleColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor whiteColor];
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 20.0;
    button1.layer.borderColor = [UIColor blueColor].CGColor;
    button1.layer.borderWidth = 1.0;
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitle:@"相机" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(cameraTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    button1.frame = CGRectMake(100, 250, 100, 50);
    button1.backgroundColor = [UIColor purpleColor];

    self.imgV = [[UIImageView alloc]init];
    [self.view addSubview:self.imgV];
    self.imgV.frame = CGRectMake(50, 350, 250, 100);
    self.imgV.backgroundColor = [UIColor greenColor];
}

#pragma mark - 选择图片
- (void)phTest {
    [HHPermissionTool requestPHAuthorizationStatusWithCompletion:^(BOOL success) {
        if (!success) {
            return;
        }
        ///必须在主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            HHPhotosViewController *vc = [[HHPhotosViewController alloc]init];
            vc.maxCount = 3;
//            nav.photosVC.delegate = self;
//            nav.allowPickingImage = YES;
//            nav.allowPickingVideo = YES;
//            nav.minImagesCount = 1;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        });
    }];
}

#pragma mark - 拍照
- (void)cameraTest {
    [HHPermissionTool requestCameraAuthorizationStatusWithCompletion:^(BOOL success) {
        if (success) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                HHNative *nat = [HHNative sharedInstance];
                [nat openCameraWithController:self];
                nat.resultAsset = ^(PHAsset *asset, NSError *error) {
                    if (!error) {
                        [HHImageManager getPhotoWithAsset:asset completionHandler:^(UIImage * _Nullable photo) {
                            [self.imgV setImage:photo];
                        }];
                    }
                };
            }
        }
    }];
}

#pragma mark HHMultiSelectPhotosViewControllerDelegate
//- (void)HHMultiSelectPhotosViewControllerUploadPhotosSucceed:(NSArray<HHAssetModel0 *> *)photoArray {
//    for (HHAssetModel0 *model in photoArray) {
//        
//        HHAssetModelMediaType t = [PhotoUtil getAssetType:model.asset];
//        NSLog(@"图片类型-%lu",(unsigned long)t);
//    }
//    NSLog(@"%@",photoArray);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
