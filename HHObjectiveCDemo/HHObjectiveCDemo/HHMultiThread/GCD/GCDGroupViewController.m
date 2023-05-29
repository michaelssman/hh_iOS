//
//  GCDGroupViewController.m
//  HHMultiThread
//
//  Created by Michael on 2020/9/24.
//  Copyright © 2020 michael. All rights reserved.
//

#import "GCDGroupViewController.h"

@interface GCDGroupViewController ()

@end

@implementation GCDGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    /**
     任务A 任务B
     任务B依赖任务A
     任务A里面是异步耗时的操作，那么先打印B的内容，后打印A的。
     B依赖A。 A的block块执行完就执行B，block块中的内容并不会等待执行完才执行B。
     */
    
}

//ABCDEF
/**
 D依赖AB
 E依赖BC
 F依赖DE
 所以3个group
 ABC并发
 */
- (void)testGroup
{
    //D ---> A, B。A和B都dispatch_group_enter(g1);
    dispatch_group_t group_d = dispatch_group_create();
    //E ---> B, C。B和C都dispatch_group_enter(g2);
    dispatch_group_t group_e = dispatch_group_create();
    //F ---> D, E
    dispatch_group_t group_f = dispatch_group_create();
    
    //value = 2
    dispatch_group_enter(group_d);//类似计数器的操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"A----");
        }
        dispatch_group_leave(group_d);
    });
    
    dispatch_group_enter(group_d);
    dispatch_group_enter(group_e);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"B----");
        }
        dispatch_group_leave(group_d);
        dispatch_group_leave(group_e);
    });
    
    dispatch_group_enter(group_e);//类似计数器的操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"C----");
        }
        dispatch_group_leave(group_e);
    });
    
    dispatch_group_enter(group_f);
    
    //A 和 B 影响D任务
    //AB执行完之后 通知D任务执行
    dispatch_group_notify(group_d, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i < 3; i++) {
                NSLog(@"D----");
            }
            dispatch_group_leave(group_f);
        });
    });
}

#pragma mark - 调度组测试
- (void)groupDemo
{
//    dispatch_group_enter(group);
//    dispatch_group_leave(group);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //加载第一张图片 进组
//    dispatch_group_async(group, queue, ^{
//        //创建调度组
//        NSString *logoStr1 = @"https://f12.baidu.com/it/u=711217113,818398466&fm=72";
//        NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr1]];
//        UIImage *image1 = [UIImage imageWithData:data1];
//        [self.mArray addObject:image1];
//    });


    //加载第二张图片 进组
//    dispatch_group_async(group, queue, ^{
//        //创建调度组
//       NSString *logoStr2 = @"https://f12.baidu.com/it/u=3172787957,1000491180&fm=72";
//        NSData *data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr2]];
//        UIImage *image2 = [UIImage imageWithData:data2];
//        [self.mArray addObject:image2];
//    });
    
    // 进组和出租 成对  先进后出
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        //创建调度组
//        NSString *logoStr2 = @"https://f12.baidu.com/it/u=3172787957,1000491180&fm=72";
//        NSData *data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr2]];
//        UIImage *image2 = [UIImage imageWithData:data2];
//        [self.mArray addObject:image2];
//        dispatch_group_leave(group);
//    });
    
//    long time = dispatch_group_wait(group, 1);
//
//    if (time == 0) {
//
//    }
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //上面图片都加载完成之后 再在这里加水印效果。
        //刷新页面UI
    });

}

@end
