//
//  OperatioViewController.m
//  HHMultiThread
//
//  Created by michael on 2021/6/21.
//  Copyright © 2021 michael. All rights reserved.
//

#import "OperatioViewController.h"

@interface OperatioViewController ()

@end

@implementation OperatioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // MARK: 队列
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    // MARK: 自定义队列 （添加到自定义队列中，自动放在子线程执行，后台执行。同时包含多种功能：串行，并发）
    NSOperationQueue *cusQueue = [[NSOperationQueue alloc]init];
    NSLog(@"mainQueue:%@ cusQueue%@",mainQueue,cusQueue);
    
    //使用NSOperationQueue(任务队列)完成多线程的操作
    //创建两个任务
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(task2) object:nil];
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(task3) object:nil];
    //创建任务队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //实现线程同步的方法：
    //1:为两个任务添加依赖关系(任务1依赖于任务2)
    [operation1 addDependency:operation2];
    //2:设置线程最大并发数为1
    [queue setMaxConcurrentOperationCount:1];
    //将任务添加到队列中
    [queue addOperation:operation2];
    [queue addOperation:operation1];
    
    /*
     队列中添加任务的时候，队列中的任务遵循先来先服务（FIFO原则）
     线程同步：后一个任务的执行必须依赖于前一个任务执行完毕。
     线程异步：（线程并发）：在分配任务的时候遵循FIFO（先来先服务）的原则，但是分配的任务同时执行，相互之间互不影响，谁先执行完毕无法预测。
     */
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"哈哈迎娶白富美");
    }];
    [queue addOperation:op];

}


- (void)task2 {
    for (int i = 0; i < 10; i++) {
        NSLog(@"出任CEO，迎娶白富美");
    }
}
- (void)task3 {
    for (int i = 0; i < 10; i++) {
        NSLog(@"努力学习，天天向上");
    }
}

@end
