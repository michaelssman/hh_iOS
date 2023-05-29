//
//  ViewController.m
//  HHOSSDemo
//
//  Created by Michael on 2018/8/24.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "HHAliyunViewController.h"
#import "AliyunOSS.h"
@interface HHAliyunViewController ()

@end

@implementation HHAliyunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.'
    AliyunOSS *uploader = [[AliyunOSS alloc]init];
    
    
    
//    MBProgressHUD *hud = [MBProgressHUD showProgress:@"正在发布..." mode:MBProgressHUDModeAnnularDeterminate];
    NSMutableArray *objects = [NSMutableArray array];
    NSMutableArray *keys = [NSMutableArray array];
    
    for (int i = 0; i < 2; i++) {
        [objects addObject:UIImagePNGRepresentation([UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]])];
        [keys addObject:[AliyunOSS generateUploadKeyWithModule:OSS_bucketName suffix:@"jpg"]];
//        [keys addObject:[NSString stringWithFormat:@"nicaicai%d.png",i]];
    }

//    uploader.hud = hud;
    [uploader uploadObjectsAsync:objects keys:keys];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
