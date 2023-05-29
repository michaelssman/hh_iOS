//
//  HHFishHookViewController.m
//  HHFishHookDemo
//
//  Created by michael on 2021/7/26.
//

/**
 fishhook（钩子），勾住代码，然后可以修改。
 自己写的C函数是HOOK不了的！！！
 */

#import "HHFishHookViewController.h"
#import "fishhook.h"
@interface HHFishHookViewController ()

@end

@implementation HHFishHookViewController

#pragma mark - 更改系统的NSLog函数
//函数指针，用来保存原始的函数地址
static void(*sys_nslog)(NSString *format,...);

//定义一个新函数。HOOK成功后NSLog调用时，会来到这里
void myNSLog(NSString *format,...) {
    format = [format stringByAppendingString:@"\n 勾上了\n"];
    //调用系统的NSLog，HOOK成功后sys_nslog指针保存的是Fundation中NSLog的地址
    sys_nslog(format);
}

#pragma mark -
void func(const char *str){
    printf("%s",str);
}

static void(*funcP)(const char *);
void newFunc(const char *str){
    printf("勾上了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //rebinding结构体
    struct rebinding nslog;
    nslog.name = "NSLog";//需要HOOK的函数名称
    nslog.replacement = myNSLog;//新函数的地址
    nslog.replaced = (void *)&sys_nslog;//保存 原始函数地址 的指针

    struct rebinding refunc;
    refunc.name = "func";
    refunc.replacement = newFunc;
    refunc.replaced = (void *)&funcP;
//    struct rebinding rebs[1] = {refunc};

    //准备数组，将一个或多个 rebinding 结构体放进去。
    struct rebinding rebs[1] = {nslog};

    /**
     用于重新绑定符号
     参数1:存放rebinding 结构体的数组
     参数2:数组的长度
     */
    rebind_symbols(rebs, 1);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    func("hello");
    NSLog(@"hello");
}
@end
