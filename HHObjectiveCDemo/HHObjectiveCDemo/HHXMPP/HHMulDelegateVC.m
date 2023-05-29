//
//  HHMulDelegateVC.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/9/7.
//

#import "HHMulDelegateVC.h"
#import <GCDMulticastDelegate.h>
#import "PersonOne.h"
#import "PersonTwo.h"

//1、定义一个协议
@protocol MyDelegate
@optional
- (void)runTo:(NSString *)string;
@end

@interface HHMulDelegateVC ()
{
    //2、在需要使用delegate的类中定义一个GCDMulticastDelegate变量
    GCDMulticastDelegate<MyDelegate> *multiDelegate;
}
@end

@implementation HHMulDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GCDMulticastDelegate<MyDelegate> *multiDelegate = (GCDMulticastDelegate <MyDelegate> *)[[GCDMulticastDelegate alloc] init];

    //3、定义多个实现了协议MyDelegate的类，如Object1和Object2；
    PersonOne *o1 = [[PersonOne alloc]init];
    PersonTwo *o2 = [[PersonTwo alloc]init];

    //4、在需要使用delegate的地方使用如下代码，将多个被委托的对象，添加到multiDelegate的delegate链中。
    [multiDelegate addDelegate:o1 delegateQueue:dispatch_get_main_queue()];
    [multiDelegate addDelegate:o2 delegateQueue:dispatch_get_main_queue()];

    [multiDelegate runTo:@"多播"];
}

@end
