//
//  GCDViewController.m
//  HHMultiThread
//
//  Created by Michael on 2020/9/24.
//  Copyright © 2020 michael. All rights reserved.
//

#import "GCDViewController.h"
#import "HHTableView.h"

@interface GCDViewController ()
@property (atomic, assign) int num;
@property (nonatomic, strong)NSMutableArray *array;
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:[[HHTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) methodNames:@[@"sync_queue",@"wbinterDemo"]]];

    //    NSLog(@"1");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"2");
//    });
//    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"3");
//    });
//    NSLog(@"4");
//    //结果 1342
    
    
    
//    //在dispatch_get_main_queue主队列中的一定是主线程
//    NSLog(@"123 - %@",[NSThread currentThread]);
//    dispatch_after(5, dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"456 - %@",[NSThread currentThread]);
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"789 - %@",[NSThread currentThread]);
//        });
//    });
//    NSLog(@"101112 - %@",[NSThread currentThread]);
    
    // MARK: 死锁
    /**
     viewDidLoad整个代码块和下面的同步代码块都是在主队列主线程，相互等待。
     viewDidLoad先添加到队列，下面的任务后添加，下面的任务要等viewDidLoad整个执行结束才执行，但是下面的任务块是在viewDidLoad代码块中的。形成死锁。
     如果下面的同步任务不是主队列就不会死锁。不在同一个队列。
     */
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"---%@--", [NSThread currentThread]);
//    });
}

#pragma mark - 队列和任务
- (void)sync_queue {
    //当前线程
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"同步全局：%@",[NSThread currentThread]);
    });
    
    //当前线程
    dispatch_sync(dispatch_queue_create("bingfa", DISPATCH_QUEUE_CONCURRENT), ^{
        sleep(3);
        NSLog(@"同步并发：%@",[NSThread currentThread]);
    });
    
    //当前线程
    dispatch_sync(dispatch_queue_create("sync_chuanxing", DISPATCH_QUEUE_SERIAL), ^{
        NSLog(@"同步串行：%@",[NSThread currentThread]);
    });
    
//    //主线程，死锁
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"同步主队列：%@",[NSThread currentThread]);
//    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"异步全局：%@",[NSThread currentThread]);
    });
    
    dispatch_queue_t serialQueue = dispatch_queue_create("chuanxing", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        sleep(0.5);
        NSLog(@"异步串行1：%@",[NSThread currentThread]);//子线程
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"异步串行2：%@",[NSThread currentThread]);//子线程
    });
    
    //同一个队列，不会开启新线程
    dispatch_queue_t queue = dispatch_queue_create("bingxing", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        sleep(0.5);
        NSLog(@"异步并行111 - %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
//            sleep(0.5);
            NSLog(@"异步并行1111 - %@",[NSThread currentThread]);
        });
    });
    dispatch_async(queue, ^{
        sleep(0.5);
        NSLog(@"异步并行222 - %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        sleep(0.5);
        NSLog(@"异步并行333 - %@",[NSThread currentThread]);
    });

    //主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"异步主队列：%@",[NSThread currentThread]);
    });
}

#pragma mark - 多线程不安全
- (void)MTDemo
{
    //美团
    __block int a = 0;
    while (a < 5) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%@ - %d",[NSThread currentThread],a);
            a++;
        });
    }
    NSLog(@"%d",a);
    //输出什么 因为上面是异步函数，耗时，并且不会阻塞，所以打印0. 这种理解错误，因为while循环，只要小于5就会一直循环，并不会打印。
    /**
     正确答案：>=5
     刚进入的时候a=0，然后进入2线程，或者3线程，进行++，因为是耗时所以并不会立即返回，就会有2线程a=0 a++，
     3线程a=0 a++，
     4线程a=0 a++，
     5线程a=0 a++，
     6线程a=0 a++，
     7线程a=0 a++，
     ...
     可能一直到50线程。
     此时2线程++完成。所有线程中的a是同一内存空间，所以所有线程的a同步修改为++ 的值。如果在a等于5的时候其他线程计算还没有完成打印那么a就是5，如果其他线程都计算完成了，那就是另外的结果。
     */
    
    /**
     上面一段代码会编译报错（Variable is not assignable (missing __block type specifier)），外部变量捕获在block空间，clang/llvm（编译）对词法和语法的编译，会识别所以会报错。    __block修饰。
     __block 底层原理：三层拷贝
     */
    /**
     上面多线程 对a资源的抢夺：加锁，同步。NSLock 信号量，
     */
    
    //    @synchronized (<#token#>) {
    //        <#statements#>
    //    }
}
- (void)KSDemo
{
    for (int i= 0; i<10000; i++) {//只循环10000次
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.num++;
        });
    }
    NSLog(@"end : %d",self.num); //可能循环完了10000次，但是后台线程还没有返回完结果，所以输出可能小于10000
}

#pragma mark - 队列
- (void)queueTest
{
    // 队列有几种
    // libdispatch.dylib - GCD 底层源码
    // 队列怎么创建 : DISPATCH_QUEUE_SERIAL / DISPATCH_QUEUE_CONCURRENT
    
    // MARK: 1.串行队列（一次执行一个任务）
    // OS_dispatch_queue_serial
    dispatch_queue_t serial = dispatch_queue_create("kc", DISPATCH_QUEUE_SERIAL);
    
    // MARK: 2.并发队列（一次可以执行多个任务）
    // OS_dispatch_queue_concurrent
    dispatch_queue_t conque = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
    // DISPATCH_QUEUE_SERIAL max && 1
    // queue 对象 alloc init class
    
    // MARK: 主队列（专门调度主线程的任务，不开辟新的线程。在主队列下的任务不管是异步还是同步 都不会开辟新线程，任务只会在主线程顺序执行）
    /**
     1. 主队列 main函数执行之前就有了 并且可以随时随地调用 并且可以%打印。
     要怎么设计mainQueue：
     C++底层使用结构体，作用域很广，静态结构体变量。
     */
    dispatch_queue_t mainQueue = dispatch_get_main_queue();//串行队列

    /**
     2. 全局队列（并发队列 有多种 所有应用程序共享的，方便编程，可以不用创建就直接使用）
     用数组设计
     */
    dispatch_queue_t globQueue = dispatch_get_global_queue(0, 0);//参数 优先级

    NSLog(@"%@-%@-%@-%@",serial,conque,mainQueue,globQueue);
    // .dq_atomic_flags = DQF_WIDTH(1),
    // .dq_serialnum = 1,
    // 串行队列必然有某些特性 VS 并发队列
    
    // dispatch_queue_create 第一个参数是label
}

//15243
- (void)testDemo
{
    //并发队列
    dispatch_queue_t queue = dispatch_queue_create("haha", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_async(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

//15234
- (void)testDemo1
{
    dispatch_queue_t queue = dispatch_queue_create("haha", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)testDemo2
{
    //同步队列
    dispatch_queue_t queue = dispatch_queue_create("haha", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    //异步函数
    dispatch_async(queue, ^{
        //2任务
        NSLog(@"2");
        //块任务
        dispatch_sync(queue, ^{//如果改为异步，则执行 1 5 2 4 3
            //3任务
            NSLog(@"3");
        });
        //4任务
        NSLog(@"4");
    });
    NSLog(@"5");
    // 1 5 2
    /**
     先执行1，因为下面是异步函数 所以执行5
     串行队列，入口比较窄，里面添加2任务，然后再加入块任务，然后再添加4任务。
     队列执行FIFO原则，所以2执行不完，后面的块任务就无法调度执行，所以优先执行2，2执行完毕执行，执行块任务。
     执行块任务的时候，又往队列里添加任务3，所以队列中任务3是在任务4之后添加的，而任务4又要等块任务执行完毕之后才能执行，任务3在任务4之后加入的队列，任务3要等任务4执行完之后才可以执行，所以就产生了死锁。
     */
//     块代码 包括大括号在内的
    //死锁
}

//MARK: - 测试函数与队列的关系
- (void)synctest
{
    // 任务 队列 函数
    //block任务块 面向函数的特性
    dispatch_block_t block = ^{
        NSLog(@"hello word");
    };
    dispatch_queue_t queue = dispatch_queue_create("com.dfjjl.cn", NULL);
    dispatch_async(queue, block);
    //队列 和 函数
}

- (void)wbinterDemo
{
    dispatch_queue_t queue = dispatch_queue_create("com.michael.cn", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1 %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2 %@",[NSThread currentThread]);
    });
    //同步
    dispatch_sync(queue, ^{
        sleep(0.5);
        NSLog(@"3 %@",[NSThread currentThread]);
    });
    NSLog(@"0 %@",[NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"7 %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"8 %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"9 %@",[NSThread currentThread]);
    });
    
    /**
     123    乱序的 根据任务的复杂程度决定谁先执行完
     30 3一定在0前面
     789    乱序
     0在主队列，0优先789，3在0前面，0在789前面，
     12和789是异步并发队列，所以12，789是乱序的。
     同步函数堵塞的是任务0。3必须在任务0之前执行。
     */
}

- (void)asynGlobal {
//    self.array = [NSMutableArray arrayWithCapacity:10000];
    self.array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 1000; i++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.array addObject:@"很快就"];
//        });
    }
    //如果i<10数组可能小于10，也可能为空
    //如果i<1000会崩溃

//    NSLog(@"数组：%@",self.array);
}

@end
