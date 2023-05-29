//
//  KeepThreadAliveController.m
//  HHRunloop
//
//  Created by michael on 2021/10/24.
//  Copyright © 2021 michael. All rights reserved.
//

#import "KeepThreadAliveController.h"
#import "KeepThread.h"
@interface KeepThreadAliveController ()
@property (nonatomic, strong)KeepThread *thread;
@property (nonatomic, assign)BOOL stopped;
@end

@implementation KeepThreadAliveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    button0.backgroundColor = [UIColor cyanColor];
    button0.layer.masksToBounds = YES;
    button0.layer.cornerRadius = 20.0;
    button0.layer.borderColor = [UIColor blueColor].CGColor;
    button0.layer.borderWidth = 1.0;
    [button0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button0 setTitle:@"线程保活" forState:UIControlStateNormal];
    [self.view addSubview:button0];
    [button0 addTarget:self action:@selector(threadKeepAlive0) forControlEvents:UIControlEventTouchUpInside];
    button0.frame = CGRectMake(100, 100, 100, 60);
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor cyanColor];
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 20.0;
    button1.layer.borderColor = [UIColor blueColor].CGColor;
    button1.layer.borderWidth = 1.0;
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitle:@"子线程执行任务" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(100, 200, 100, 60);
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor cyanColor];
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 20.0;
    button2.layer.borderColor = [UIColor blueColor].CGColor;
    button2.layer.borderWidth = 1.0;
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitle:@"停止runloop" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(100, 300, 100, 60);
}
#pragma mark - 线程保活
- (void)threadKeepAlive0 {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        self.thread = [[KeepThread alloc]initWithBlock:^{
            NSLog(@"startRun");
            //在线程中获取并启动添加了source的Runloop
            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
            while (!weakSelf.stopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            NSLog(@"stopped");
        }];
        self.thread.name = @"keepAliveThread";
        [self.thread start];
    });
}
//调用子线程执行任务
- (void)callAction {
    [self performSelector:@selector(doSomething) onThread:self.thread withObject:nil waitUntilDone:NO];
}
- (void)doSomething {
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}
- (void)stopAction {
    //子线程调用stop
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}
- (void)stopThread {
    //设置标记为NO
    self.stopped = YES;
    //停止runloop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    
    //停止强引用
    self.thread = nil;
}

#pragma mark - GCDKeepAlive
- (void)GCDKeepAlive {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [runloop run];
    });
}

#pragma mark - 线程保活
/**
 1.子线程保活，避免创建线程产生的消耗
 2.检测卡顿
 3. 子线程检测 不断的给主线程发消息，子线程主线程是分开的
 */
static NSThread *ThreadKeepAlive_;

- (void)threadKeepAlive
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ThreadKeepAlive_ = [[NSThread alloc] initWithBlock:^{
            [self _threadKeepAliveRunLoop];
        }];
        [ThreadKeepAlive_ setName:@"ThreadKeepAlive"];
        [ThreadKeepAlive_ setQualityOfService:[[NSThread mainThread] qualityOfService]];
        [ThreadKeepAlive_ start];
    });
    
}
static NSRunLoop *ThreadKeepAliveRunLoopRef_;
- (void)_threadKeepAliveRunLoop
{
    ThreadKeepAliveRunLoopRef_ = NSRunLoop.currentRunLoop;
    //主线程
    //source1
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
    
//    [self.class addRunLoopObserver:CFRunLoopGetCurrent()];
    //source0 source1
    //source1主动触发事件
    
//    [[NSRunLoop currentRunLoop] run];//不可取，会让线程进入永久循环，不能退出。失控。
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];//超时时间，runloop处理完之后或者到了指定时间，就会结束，用的时候还需要手动开启
    
}

- (void)runloopStopWakeUp
{
    CFRunLoopStop(ThreadKeepAliveRunLoopRef_.getCFRunLoop);
//    CFRunLoopWakeUp(ThreadKeepAliveRunLoopRef_.getCFRunLoop);
}

@end
