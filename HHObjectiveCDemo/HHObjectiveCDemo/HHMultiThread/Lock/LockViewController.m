//
//  LockViewController.m
//  HHMultiThread
//
//  Created by Michael on 2020/9/19.
//  Copyright © 2020 michael. All rights reserved.
//

#import "LockViewController.h"

@interface LockViewController ()

/// 票数
@property (nonatomic, assign) NSInteger ticketCount;
@property (nonatomic, strong) NSMutableArray *ticketsArr;

/// 信号量semaphore
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self setTitle:@"ThreadSafe"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    /*
     线程互斥和线程死锁：
     线程互斥：多个线程在同时访问同一块公共资源的时候出现的争抢现象称为线程互斥。解决线程互斥的方式-上锁
     线程死锁：线程在修改资源的时候只是有上锁的过程没有解锁的过程。外边的线程在等待里面的线程解锁，这种等待会一直进行下去。
     */
    
    // 实例化各种锁
    _semaphore = dispatch_semaphore_create(1);
    
    _ticketCount = 30;
    _ticketsArr = [NSMutableArray array];
    [self multiThread];

}

- (void)multiThread {
    
    dispatch_queue_t queue = dispatch_queue_create("MultiThreadSafeQueue", DISPATCH_QUEUE_CONCURRENT);

    for (NSInteger i=0; i<10; i++) {
        dispatch_async(queue, ^{
            [self testDispatchSemaphore:i];
        });
    }
    
//    for (NSInteger i=0; i<10; i++) {
//        dispatch_async(queue, ^{
//            [self testSynchronized];
//        });
//    }
}

#pragma mark - dispatch_semaphore
/**
 dispatch_semaphore_wait计数减1
 dispatch_semaphore_signal计数加1
 */
- (void)testDispatchSemaphore:(NSInteger)num {
    
    while (1) {
        // 参数1为信号量；参数2为超时时间；ret为返回值
        //dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        //计数减1
        long ret = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.21*NSEC_PER_SEC)));
        if (ret == 0) {
            if (_ticketCount > 0) {
                NSLog(@"%d 窗口 卖了第%d张票", (int)num, (int)_ticketCount);
                _ticketCount --;
            }
            else {
                dispatch_semaphore_signal(_semaphore);
                NSLog(@"%d 卖光了", (int)num);
                break;//跳出循环
            }
            [NSThread sleepForTimeInterval:0.2];
            dispatch_semaphore_signal(_semaphore);
        }
        else {
            NSLog(@"%d %@", (int)num, @"超时了");
        }
        
        [NSThread sleepForTimeInterval:0.2];
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
