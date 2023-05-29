//
//  ViewController.m
//  HHCrash
//
//  Created by Michael on 2020/7/5.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHCrashTestViewController.h"
@interface HHCrashTestViewController ()

@end

@implementation HHCrashTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    [self removeObserver:self forKeyPath:@"woshi"];

//    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 100, 60)];
//    tf.backgroundColor = [UIColor redColor];
//    [self.view addSubview:tf];
}

- (void)OCExceptionCrash
{
    NSArray *array = @[@"hfghtrd",@"fdst",@"sdf"];
    //app为什么退出？ 线程做一些操作导致退出
//    [array objectAtIndex:5];
    NSLog(@"%@",array[5]);
    NSDictionary *dic = @{@"kkk":@"fds"};
    NSLog(@"%lu",(unsigned long)[dic[@"haha"] length]);
}
- (void)signalAction
{
    void *signal = malloc(1024);
    free(signal);
    free(signal);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self OCExceptionCrash];
}
@end
