//
//  ViewController.m
//  HHRunloop
//
//  Created by Michael on 2020/8/11.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHRunloopViewController.h"
#import "KeepThreadAliveController.h"
@interface HHRunloopViewController ()

@end

@implementation HHRunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@"---%@",[NSRunLoop currentRunLoop]);
    //打印出来的是CFRunLoop的结构体
    
    //runloop和线程是一一对应的关系
    //获取当前runloop 的时候，会return _CFRunLoopGet0(pthread_self());传的就是当前线程
    /**
     RunLoop要执行依赖于：
     输入源        port
     source        source0（处理CFSocket）和source1（mach_msg消息 触摸事件的传递）
     定时器        timer
     RunLoop要有事件。没有事件 运行一下就退出了。
     */
    
    //消息队列。线程和进程间的通讯。
    
    //往当前runloop注册定时器 runloop有的事件，固定的时间间隔执行当前任务
    //唤醒 休眠 唤醒 执行任务 休眠重复步骤
    //Tracking mode下会失效， 需要同步到commondes
    [NSTimer timerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer fire");
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[KeepThreadAliveController new] animated:YES];
    return;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        //在子线程，一次性的事件。执行一次之后  runloop的事件源执行完成，runloop就会退出
//        [NSTimer timerWithTimeInterval:1.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
//            NSLog(@"timer fire");
//        }];
//        [[NSRunLoop currentRunLoop] run];
//
//        //runloop 源码分析 为什么可以同步到不同的mode
//        //addTimer底层是C函数的CFRunloopAddTimer
//        [[NSRunLoop currentRunLoop] addTimer:<#(nonnull NSTimer *)#> forMode:NSRunLoopCommonModes];
//        NSLog(@"runloop 退出");
        
        NSLog(@"----1");
        //和runloop有关系 有delay -- timer 注册定时器满足延时的需要。注册timer事件在当前runloop中，想要test执行，必须得打开runloop。
        [self performSelector:@selector(test) withObject:nil afterDelay:0];
        /**
         //等同于下面这句 是一次性任务 执行完成之后 就没有事件源输入源保证runloop有任务去做。
         [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
         [self test];
         }];
         */
        
        [self performSelector:@selector(test) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
        //NO 打印1 3 代表当权runloop没有退出 是否需要一直等 是NO的时候就像runloop注册了source事件源。
        //YES 打印1 3 2
        
        //和runloop没有任何关系，与当前runloop开不开启没有任何关系，都会执行test。 是NSObject方法，底层调用objc_msgSend来查找方法执行 借助NSInvocation执行。
        [self performSelector:@selector(test) withObject:nil];//打印1 3 2
        
        /**
         runloop三种启动方式
         这三种 最底层调用的是同一个api。
         */
        [[NSRunLoop currentRunLoop] run]; //打印1 3 2
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];//runloop的启动方式改成这个。还是打印1 3 2
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];//打印还是1 3 2
        //2被打印，说明runloop退出了
        NSLog(@"----2");
    });
}

/**
 触摸屏幕。打印 1 3 2
 */
- (void)test
{
    NSLog(@"3 - %@",[NSThread currentThread]);
}

//runloop运行的三种方法
//都是调的runMode BeforeDate
/**
 runMode BeforeDate中调的CFRunLoopRunInMode( , , )
 */
- (void)runloopRun
{
//    //1
//    [[NSRunLoop currentRunLoop] run];
//    //2
//    [[NSRunLoop currentRunLoop] runMode:<#(nonnull NSRunLoopMode)#> beforeDate:<#(nonnull NSDate *)#>];
//    //3 只有这一种可以 停止runloop，线程保活中会使用。
//    [[NSRunLoop currentRunLoop] runUntilDate:<#(nonnull NSDate *)#>];
}

@end
