//
//  TimerViewController.m
//  HHRunloop
//
//  Created by Michael on 2020/9/1.
//  Copyright © 2020 michael. All rights reserved.
//

#import "TimerViewController.h"
#import "HHProxy.h"
#import <objc/runtime.h>
@interface TimerViewController ()
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)id target;//第二种
@property (nonatomic, strong)HHProxy *proxy;//第三种
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /**
     timer为什么能在未来某一时间执行定时任务：因为和runloop有关。
     timer会对self强引用 strong 调用retain 引用计数加1。
     */
//    __weak __typeof(self) weakSelf = self;
//    [NSTimer timerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
//        weakSelf.title = @"timerblock";
//    }];
    // timer加到了runloop中，runloop是个循环，runloop不退出，一直强持有timer，timer强引用block，block强引用self，所以VC不能被释放
    
    //timer注册到了runloop，runloop持有timer，timer强持有self。
    //runloop和线程是一一对应的，当前是主线程，主线程不退出，
//    // timer强引用了target，也就是self。
//    // 所以只要runloop循环不退出 就没有办法回收self（viewController）。不走VC的dealloc方法。
//    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fire) userInfo:nil repeats:YES];//有内存泄漏。定时器不会停止，需要在dealloc中执行Timer的invalidate。
//    //等同于下面
//    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(fire) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    
    //第三种
    //NSProxy 抽象基类，和NSObject一样。 负责把消息转发到真正类的一个代理类，相当于一个中间者。
    _proxy = [HHProxy proxyWithTarget:self];//只有alloc方法 没有init方法。target是weak 并不会使vc引用计数加1，
    //借用一个中间者，将当前的target设置为第三者。
    //timer对_proxy是强引用，_proxy.target对self是弱引用，vc可以正常调用dealloc。在dealloc中释放了timer，都能够正常的释放。
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:_proxy selector:@selector(fire) userInfo:nil repeats:YES];//循环引用

    
    
    //runloop是一个运行循环，处理既定的时间，当有外来的事件的时候，来处理。
}

#pragma mark - 第二种
//中介者模式   不方便使用self 换其它对象
- (void)method2 {
    //timer不直接强引用VC，通过消息转发
    //self引用target，self.timer引用target，timer不引用self。vc可以正常调用dealloc。在dealloc中释放了timer，都能够正常的释放。
    _target = [[NSObject alloc]init];
    //动态添加方法
    class_addMethod([_target class], @selector(fire), class_getMethodImplementation([self class], @selector(fire)), "v@:");
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:_target selector:@selector(fire) userInfo:nil repeats:YES];
//    FBKVO
//    [NSRunLoop currentRunLoop] -> timer -> _target
}

#pragma mark - 第三种
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - 第四种
- (void)method4{
    //苹果自己优化处理
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        //
    }];
}


- (void)fire
{
    NSLog(@"fire");
}

//调用析构函数的时候，系统rumtime会自动的destoryweak，遍历弱引用表，把弱引用表清空。
- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
