//
//  HHTraceViewController.m
//  StartOptimization
//
//  Created by michael on 2021/9/2.
//  本地符号，如果不使用，符号不会生成。

#import "HHTraceViewController.h"
#import "HHTraceManager.h"
#import <HHF1/HHF1.h>
#import <HHF2/HHF2.h>
@interface HHTraceViewController ()

@end

@implementation HHTraceViewController
//全局符号 外界也可以调用
void test5(){
}
//作用在本文件。本地符号
static void test6(){
    
}
- (void)test1
{
    NSLog(@"%s",__func__);
}

- (void)test2
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%s",__func__);

    // Do any additional setup after loading the view.
    [self test1];
    [self test2];
    
    [[HHFCode alloc]init];
}

void test3()
{
    NSLog(@"%s",__func__);
}

void test4()
{
    NSLog(@"%s",__func__);
}

+ (void)load
{
    NSLog(@"%s",__func__);
    test3();
    test4();
}

//生成order文件！！
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HHTraceManager *trace = [[HHTraceManager alloc]init];
    [trace createOrderFile];
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
