//
//  HHAllocViewController.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/5/14.
//

#import "HHAllocViewController.h"
#import "LGPerson.h"
#import <malloc/malloc.h>
@interface HHAllocViewController ()

@end

@implementation HHAllocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //b bl 跳转指令（函数的调用）
    //ret 函数的返回
    //;注释
    
    //寄存器 运算器 控制器
    
    //alloc
    //对象如何被创建出来的
    //1. alloc之后 内存地址就已经分配了  2.new
    LGPerson *p = [LGPerson alloc];
    p.age = 10;
    LGPerson *p1 = [p init];//init不会开辟内存空间
    LGPerson *p2 = [p init];
    //    LGPerson *p1 = p;
    //    LGPerson *p2 = p;
    
    NSLog(@"p1 = %@,p2 = %@",p1,p2);//p1和p2内存地址一样，说明p1和p2是同一个对象
    NSLog(@"%d %d",p1.age,p2.age);//同一内存中的属性，都是10
    
    p.name = @"hello";
    p.hobby = @"girl";
    p.hight = 1.80;
    p.age = 20;
    p.number = 123;
    NSLog(@"%zu",malloc_size((__bridge const void *)(p)));
    
}

@end
