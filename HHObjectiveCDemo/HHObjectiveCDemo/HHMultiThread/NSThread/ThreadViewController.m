//
//  ThreadViewController.m
//  HHMultiThread
//
//  Created by michael on 2021/6/21.
//  Copyright © 2021 michael. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()
@property (nonatomic, strong)UIImageView *photo;

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //打印当前运行的线程
    NSLog(@"%@ %d",[NSThread currentThread],[NSThread currentThread].isMainThread);
    
    //1:使用NSThread(线程类)创建子线程
    //MARK: 1. 系统自动创建子线程
    //类方法
    [NSThread detachNewThreadSelector:@selector(task1) toTarget:self withObject:nil];//withObject:<#(id)#> 参数
    
    //MARK: 2. 手动创建子线程(手动开辟的子线程需要我们自己手动开启)
    //对象方法
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(task1) object:nil];// object:nil  参数
    thread.name = @"hh_thread";
    //优先级 从0到1
    [thread setThreadPriority:0.9];
    [thread start];//开启子线程
    
    //MARK: 3. 通过NSObject提供的获取子线程的方式
    [self performSelectorInBackground:@selector(task1) withObject:nil];
    
    self.photo = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.photo.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.photo];
    
    //将下载任务交给子线程来完成
    //    [self performSelectorInBackground:@selector(downLoadImage) withObject:nil];
    
    //    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(printfStar) userInfo:nil repeats:YES];
}

#pragma mark - 退出线程
- (void)exitThread {
    [[NSThread currentThread] cancel];
    if ([[NSThread currentThread] isCancelled]) {
        [NSThread exit];
    }
}

- (void)task1 {
    NSLog(@"%@  %d",[NSThread currentThread],[NSThread currentThread].isMainThread);
    sleep(4);
}

#pragma mark DownLoad Image
/*
 子线程完成的操作存在的问题：
 （1）在子线程完成的操作的附近系统不会添加自动释放池。为了避免出现内存泄露，我们需要手动添加自动释放池
 (2)在子线程中事件循环处理机制默认是关闭的，需要手动开启该循环处理机制。但是在主线程中事件循环处理机制默认是开启的。
 */
////图片异步下载
//- (void)downLoadImage {
//    @autoreleasepool {
//        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(printfStar) userInfo:nil repeats:YES];
//        //开始事件循环处理机制
//        [[NSRunLoop currentRunLoop] run];
//
//        [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(printfStar) userInfo:nil repeats:YES];
//        //在网络请求中请求过程耗时的操作我们需要提交给子线程完成。但是当数据回来时，对于界面数据的刷新操作应该交给主线程来完成
////        将任务转回到主线程
//        NSLog(@"%@",imageData);
//    }
//}

////图片异步下载
- (void)downLoadImage {
    // 请求数据
    NSData *imageData = [self requestData];
    // 回到主线程更新UI
    [self performSelectorOnMainThread:@selector(refreshImageData:) withObject:imageData waitUntilDone:YES];
}

#pragma mark - 请求图片数据
- (NSData *)requestData {
    //图片从网络上下载过来的是二进制流形式
    NSURL *url = [NSURL URLWithString:@"https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/image/AppleInc/aos/published/images/a/pp/apple/products/apple-products-section1-one-holiday-201811?wid=2560&hei=1046&fmt=jpeg&qlt=95&op_usm=0.5,0.5&.v=1540576114151"];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    return imageData;
}

//界面数据的刷新操作
- (void)refreshImageData:(NSData *)imageData {
    self.photo.image = [UIImage imageWithData:imageData];
}

- (void)printfStar {
    NSLog(@"*****");
}

@end
