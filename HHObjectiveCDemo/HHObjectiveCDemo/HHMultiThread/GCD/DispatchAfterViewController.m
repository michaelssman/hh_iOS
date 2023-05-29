//
//  DispatchAfterViewController.m
//  HHMultiThread
//
//  Created by michael on 2021/8/10.
//  Copyright © 2021 michael. All rights reserved.
//

#import "DispatchAfterViewController.h"

@interface DispatchAfterViewController ()

@end

@implementation DispatchAfterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - after
/*
 1.gcd误差要大
 2.gcd不可以取消延时
 3.perfromselect  runloop要手动开启 主线程的runloop是默认开启的，而子线程需手动开启
 */
- (void)after{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self performSelector:@selector(afterEvent:) withObject:self afterDelay:2];
        NSLog(@"begin");
        [[NSRunLoop currentRunLoop] run];
    });
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"1");
    });
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)afterEvent:(id)sender{
    NSLog(@"2");
}

@end
