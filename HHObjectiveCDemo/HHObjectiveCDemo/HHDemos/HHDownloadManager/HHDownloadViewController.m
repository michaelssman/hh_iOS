//
//  ViewController.m
//  HHDownloadManager
//
//  Created by Michael on 2019/8/15.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHDownloadViewController.h"
#import "HHDownloadManager.h"
@interface HHDownloadViewController ()

@end

@implementation HHDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HHDownloadModel *model = [[HHDownloadManager sharedManager] downloadURLString:@"https://tiebapic.ningmengyun.com/courseware_test/1701702/%E6%B5%8B%E8%AF%95%E8%AF%BE%E4%BB%B6000.pdf" destPath:nil];
    model.progress = ^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        NSLog(@"下载进度：%ld, %ld, %f",(long)receivedSize,(long)expectedSize,progress);
    };
    
    
    //aa和dd不一样 编码两次结果不同 所以有中文时不能多次编码
    NSString*ss = @"https://tiebapic.ningmengyun.com/courseware_test/1701702/%E6%B5%8B%E8%AF%95%E8%AF%BE%E4%BB%B6000.pdf";
    NSString *aa = [ss stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *dd = [aa stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"\n111：%@\n222:%@",aa,dd);
    
    
    //下载进度
    HHDownloadModel *downloadModel = [[HHDownloadManager sharedManager] downloadState:@""];
    if (downloadModel.downloadState == HHDownloadStateCompleted) {
        //下载完成
    } else {
        downloadModel.progress = ^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            //下载进度
        };
    }
}


@end
