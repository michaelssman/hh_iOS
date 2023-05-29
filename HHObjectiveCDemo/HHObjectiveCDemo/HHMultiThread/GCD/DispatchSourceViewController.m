//
//  DispatchSourceViewController.m
//  HHMultiThread
//
//  Created by michael on 2021/8/10.
//  Copyright © 2021 michael. All rights reserved.
//

#import "DispatchSourceViewController.h"

@interface DispatchSourceViewController ()
@property (nonatomic, strong)dispatch_source_t timer;

@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, assign) NSUInteger totalComplete;
@property (nonatomic) BOOL isRunning;
@end

@implementation DispatchSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - source
- (void)sourceDemo
{
    self.queue = dispatch_queue_create("ahua.com", NULL);
    
    //创建源
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    
    //绑定事件句柄 回调
    dispatch_source_set_event_handler(self.source, ^{
        
        NSLog(@"%@",[NSThread currentThread]);
        
        NSUInteger value = dispatch_source_get_data(self.source);
        self.totalComplete += value;
        NSLog(@"进度: %.2f",self.totalComplete/100.0);
    });
    
    self.isRunning = YES;
    dispatch_resume(self.source);
}
- (void)didClickStartOrPauseAction:(id)sender {
    
    if (self.isRunning) {
        dispatch_suspend(self.source);
        dispatch_suspend(self.queue);
        NSLog(@"已经暂停");
        self.isRunning = NO;
        [sender setTitle:@"暂停中.." forState:UIControlStateNormal];
    }else{
        dispatch_resume(self.source);
        dispatch_resume(self.queue);
        NSLog(@"已经执行了");
        self.isRunning = YES;
        [sender setTitle:@"暂停中.." forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"开始了");
    for (int i= 0; i<100; i++) {
        dispatch_async(self.queue, ^{
            if (!self.isRunning) {
                NSLog(@"已经暂停");
                return;
            }
            sleep(1);
            //每次向源里传一个1
            dispatch_source_merge_data(self.source, 1);
        });
    }
}

#pragma mark - 定时器
//定时器
/*
 timer要设全局变量
 nstimer延时误差要大
 nstimer会有循环引用的问题
 runloop nsdefaultrunloop tractingrunloop
 */
- (void)timer
{
    // 每intervalTime秒执行一次
    CGFloat intervalTime = 2.0;
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, intervalTime * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"1");
    });
    dispatch_resume(self.timer);
}

/// 暂停计时
- (void)pause
{
    dispatch_suspend(self.timer);
}

/// 结束计时
/**
 结束定时器前，一定要先将suspend 的dispatch 先resume ，再cancel---
 一定要注意释放内存，不停止的话，会一直不断的在计时。
 */
- (void)end
{
    dispatch_source_cancel(self.timer);
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
