//
//  HHRecursiveLockVC.m
//  HHMultiThread
//
//  Created by michael on 2021/8/19.
//  Copyright © 2021 michael. All rights reserved.
//

#import "HHRecursiveLockVC.h"

@interface HHRecursiveLockVC ()
/// 递归锁
@property (nonatomic, strong) NSRecursiveLock *recursiveLock;
@end

@implementation HHRecursiveLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.recursiveLock = [[NSRecursiveLock alloc] init];
    
    [self lg_testRecursive];
    
}

#pragma mark -- NSRecursiveLock

- (void)lg_testRecursive{
    
    NSLock *lock = [[NSLock alloc] init];
    //错误方法
    for (int i= 0; i<10; i++) {//会发生多线程问题 使用NSLock不行，因为下面的代码有递归
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            static void (^testMethod)(int);
            testMethod = ^(int value){
                //业务代码
                [lock lock];//不断递归加锁，走不到下面所以就死锁了
                if (value > 0) {
                    NSLog(@"current value = %d",value);
                    testMethod(value - 1);
                }
                [lock unlock];
            };
            testMethod(10);
        });
    }
    
    //正确方法1
    for (int i= 0; i<10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            static void (^testMethod)(int);
            [lock lock];
            testMethod = ^(int value){
                NSLog(@"当前线程：%@",[NSThread currentThread]);
                if (value > 0) {
                    NSLog(@"current value = %d",value);
                    testMethod(value - 1);
                }
            };
            testMethod(10);
            [lock unlock];
        });
    }
    
    //最正确方法2 可多线程 可递归
    // @synchronized -> recursiveLock (多线程性) -> lock 递归性
    for (int i= 0; i<10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            static void (^testMethod)(int);
            testMethod = ^(int value){
                @synchronized (self) {
                    NSLog(@"当前线程：%@",[NSThread currentThread]);
                    if (value > 0) {
                        NSLog(@"current value = %d",value);
                        testMethod(value - 1);
                    }
                }
            };
            testMethod(10);
        });
    }
    
    //正确方法3 只打印一遍10到1 因为无法进行多线程的可递归
    for (int i= 0; i<10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            static void (^testMethod)(int);
            testMethod = ^(int value){
                [self.recursiveLock lock];
                if (value > 0) {
                    NSLog(@"current value = %d",value);
                    testMethod(value - 1);
                }
                [self.recursiveLock unlock];
            };
            testMethod(10);
        });
    }
    
}

@end
