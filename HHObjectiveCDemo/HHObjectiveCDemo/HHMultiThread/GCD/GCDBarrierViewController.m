//
//  GCDBarrierViewController.m
//  HHMultiThread
//
//  Created by michael on 2021/6/21.
//  Copyright © 2021 michael. All rights reserved.
//

#import "GCDBarrierViewController.h"
#import "HHTableView.h"
@interface GCDBarrierViewController ()
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@end

@implementation GCDBarrierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:[[HHTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) methodNames:@[@"dispatchBarrier",@"demo2",@"demo3",@"readWriteLock"]]];
    //barrier（访问数据库或者文件的时候 ，读-写锁）
}

/**
 输出结果：
 barrier start
 barrier end
 asyncTask_2
 asyncTask_1
 barrier_asyncTask
 asyncTask_4
 */
- (void)dispatchBarrier
{
    NSLog(@"barrier start %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("hhmutiThreadQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:7];
        NSLog(@"asyncTask_1 %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"asyncTask_2 %@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{//不会阻塞barrier end
        NSLog(@"barrier_asyncTask %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:3];
    });
//    dispatch_barrier_sync(queue, ^{//会阻塞barrier end
//        NSLog(@"barrier_syncTask %@",[NSThread currentThread]);
//        [NSThread sleepForTimeInterval:4];
//    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"asyncTask_4 %@",[NSThread currentThread]);
    });
    
    NSLog(@"barrier end %@",[NSThread currentThread]);
}

/**
 栅栏函数的演示说明:dispatch_barrier_sync/dispatch_barrier_async
 */
- (void)demo2
{
    // why ? 看底层源码 + 控制流程
    // 问题: ? 栅栏函数使用问题 ---  调度组 -- 信号量
    dispatch_queue_t concurrentQueue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t concurrentQueue1 = dispatch_queue_create("kc", DISPATCH_QUEUE_CONCURRENT);
    /**
     dispatch_queue_t concurrentQueue = dispatch_get_global_queue(0, 0);
     全局并发队列不允许栅栏，只能使用自定义并发队列
     这时输出：**********起来干!!        123    加载那么多,喘口气!!!        栅栏函数2        456
     */
    
    // 这里是可以的额!
    /* 1.异步函数 */
    dispatch_async(concurrentQueue, ^{
        NSLog(@"123");
    });
    
    dispatch_async(concurrentQueue, ^{
        sleep(1);
        NSLog(@"456");
    });
    /* 2. 栅栏函数 */ // - dispatch_barrier_sync
    dispatch_barrier_async(concurrentQueue1, ^{
        NSLog(@"----%@-----",[NSThread currentThread]);
    });
    /* 3. 异步函数 */
    dispatch_async(concurrentQueue, ^{
        NSLog(@"加载那么多,喘口气!!!");
    });
    // 4
    NSLog(@"**********起来干!!");
    
}

/**
 可变数组 线程不安全 解决办法
 */
- (void)demo3
{
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
    // 可变数组线程安全?
    dispatch_queue_t concurrentQueue = dispatch_queue_create("hhh", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(0, 0);
    // 多个线程同时操作可变数组marray
    for (int i = 0; i<1000; i++) {
        __block UIImage *image;
        dispatch_async(concurrentQueue, ^{
            NSString *imageName = [NSString stringWithFormat:@"333.png"];
            NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data];
            
            //            [self.mArray addObject:image];
            /**
             线程不安全 读写出问题 需要放到下面
             mArray里写 写任务是对旧值release 新值retain 一边写一边读 读的时候可能其他线程在release，读取到了野指针。
             */
            
            // self.mArray 多线程 self.mArray地址永远是一个
            // self.mArray 0 - 1 - 2 数组变化
            // 例：name = kc  先getter - 再setter (对新值retain 对旧值release)
            // self.mArray 读 - 写  self.mArray = newaRRAY (1 2)
            // 多线程 同时  写  1: (1,2)  2: (1,2,3)  3: (1,2,4) 线程1add没结束 线程2就开始add就会出问题
            // 同一时间对同一片内存空间进行操作 不安全 会有异常
        });
        dispatch_barrier_async(concurrentQueue , ^{//前面的线程栅栏函数回来之后才能进行下一次的栅栏函数
            [mArray addObject:image];
            NSLog(@"mArray.count:%lu",(unsigned long)mArray.count);
        });
    }
}

#pragma mark - 读写锁
- (void)readWriteLock {
    // 使用自己创建的并发队列
    self.concurrentQueue = dispatch_queue_create("aaa", DISPATCH_QUEUE_CONCURRENT);
    // 使用全局队列,必定野指针崩溃
//    self.concurrentQueue = dispatch_get_global_queue(0, 0);
 
    // 测试代码,模拟多线程情况下的读写
    for (int i = 0; i<10; i++) {
        // 创建10个线程进行写操作
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self updateText:[NSString stringWithFormat:@"噼里啪啦--%d",i]];
        });
     }
 
    for (int i = 0; i<50; i++) {
        // 50个线程进行读操作
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getCurrentText];
//            NSLog(@"读 %@ %@",[self getCurrentText],[NSThread currentThread]);
        });
 
    }
 
    for (int i = 10; i<20; i++) {
        // 10个进行写操作
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self updateText:[NSString stringWithFormat:@"噼里啪啦--%d",i]];
        });
 
    }
}
 
// 写操作,栅栏函数是不允许并发的,所以"写操作"是单线程进入的,根据log可以看出来
- (void)updateText:(NSString *)text {
    // block内不需要使用weakSelf, 不会产生循环引用
    dispatch_barrier_async(self.concurrentQueue, ^{
        self.text = text;
        NSLog(@"写操作 %@ %@",text,[NSThread currentThread]);
        // 模拟耗时操作,打印log可以放发现是1个1个执行,没有并发
        sleep(1);
    });
}
// 读操作,这个是可以并发的,log在很快时间打印完
- (NSString *)getCurrentText {
    __block NSString * t = nil;
    // block内不需要使用weakSelf, 不会产生循环引用
    dispatch_sync(self.concurrentQueue, ^{
        NSLog(@"读 %@",[NSThread currentThread]);
        t = self.text;
        // 模拟耗时操作,瞬间执行完,说明是多个线程并发的进入的
        sleep(1);
    });
    return t;
}
@end
