//
//  HHBlockViewController.m
//  HHBlock
//
//  Created by Michael on 2020/8/7.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHBlockViewController.h"
#import "NSObject+Block.h"

static HHBlockViewController *staticSelf_;

typedef void(^HHBlock) (void);
typedef void(^HHBlockP) (HHBlockViewController *);

@interface HHBlockViewController ()
@property (nonatomic, strong)HHBlock block;
@property (nonatomic, copy)HHBlockP block1;
@property (nonatomic, copy)NSString *name;


@property (nonatomic, copy) HHBlock doWork;
@property (nonatomic, copy) HHBlock doStudent;

@end

@implementation HHBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //循环引用问题
    /**
     一个A 一个B，A持有一个B之后就会向B发一个信号，B就会retain count+1，这个操作编译器已经自动帮我们处理了。引用计数器加1处理。
     B要释放就需要A对B发release，引用计数减1。
     
     A持有B，B里面又持有A。
     因为B持有A，A无法调用dealloc给B放信号
     B接不到release信号，retainCount不等于0，dealloc就不会被调用
     
     block循环引用原因：self持有block。block代码块里面有self
     */
    self.name = @"哈哈哈";
    //产生循环引用 block里面对self捕获
    self.block = ^{
        NSLog(@"%@",self.name);
    };
    
    //这种没有相互持有 animations这个block是UIView类持有，并不是self，跟self没关系。没有循环引用。
    [UIView animateWithDuration:1 animations:^{
        NSLog(@"%@",self);
    }];
    [self blockType];
    [self blockDemo3];
    [self block_weak_strong];
    [self testBlockFunc];
}

#pragma mark - 3种block
- (void)blockType {
    //block 分类。 多种block
    /**
     block是一个对象：有isa指针的指向 使用clang编译之后是个结构体 并且里面有isa
     为什么能保存代码块：
     为什么要调用 不调用行不行：
     捕获外界变量：为什么能够捕获外界变量
     <__NSGlobalBlock__: 0x10397f038> 全局block
     <__NSMallocBlock__: 0x60000397b990> 堆区的block
     <__NSStackBlock__: 0x7ffeee1a8130>
     所以一开始创建的^{
         //保存一份代码块
         NSLog(@"hello 世界 %d",a);
     }这一块是栈区block。然后用一个变量接收拷贝到了全局block，如果捕获外部变量的话就又变成了堆区block。
     还有一种栈区block MRC中比较多 ARC比较少。
     */
    
    //1. __NSGlobalBlock__ 没有捕获任何的外界变量（除非是全局区的（静态变量））
    void (^globalBlock)(int, int) = ^(int a, int b){
        NSLog(@"%d",a+b);
    };
    NSLog(@"globalBlock:%@",globalBlock);//__NSGlobalBlock__

    //2. 堆block __NSMallocBlock__
    //生命周期由程序员手动管理，栈block如果有强指针引用或copy修饰的成员属性引用就会被拷贝到堆中，变成堆block
    //下面面代码也没用看到strong 或 copy修饰符，但是为什么会强引用的，因为在ARC环境下，我们在声明变量的时候，前面是会被默认加上 __strong 修饰符的。所以我们在ARC下声明的Block一般都是堆block。
    int a = 10;
    void (^mallocBlock)(void) = ^{//copy
        //保存一份代码块
        NSLog(@"hello %d",a);
    };
    NSLog(@"block:%@--%@",mallocBlock,[mallocBlock copy]);

    //3. 加__weak变栈block __NSStackBlock__ 捕获了a但是没有被block强引用持有的时候 就是栈block
    //生命周期由系统控制，函数返回即销毁，用到局部变量、成员属性\变量，且没有强指针引用的block都是栈block
    int a1 = 10;
    void (^__weak stackBlock)(void) = ^{//copy
        //保存一份代码块
        NSLog(@"hello 世界 %d",a1);
    };
    NSLog(@"%@",stackBlock);

    //打印<__NSGlobalBlock__: 0x10397f038>
    //上面添加完int a之后 变成了<__NSMallocBlock__: 0x60000397b990>
    NSLog(@"%@",^{
        //保存一份代码块
        NSLog(@"hello 世界 %d",a1);
    });//打印这一块就是栈区block。存在的生命周期比较短 <__NSStackBlock__: 0x7ffeee1a8130>   MRC  ARC下还是全局block 引用外部变量就是堆区block。
}

#pragma mark - block 捕获外部变量-对外部变量的引用计数处理
- (void)blockDemo2{
    /**
     结果：1   3   4   5
     */
    
    NSObject *objc = [NSObject new];
    NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(objc))); // 1
    // block 底层源码
    // 属性捕获：引用计数 + 1
    // 堆区block
    // 内存从栈block变成堆block：引用计数  + 1
    void(^strongBlock)(void) = ^{ // 1 - 栈block -> 捕获objc + 1 = 2 栈copy拷贝到堆（对里面成员变量也会copy） +1 = 3
        NSLog(@"---%ld",CFGetRetainCount((__bridge CFTypeRef)(objc)));
        //block对objc进行了捕获，底层生成了objc成员变量进行持有
    };
    strongBlock();

    //栈block
    void(^__weak weakBlock)(void) = ^{ // + 1 栈block捕获变量 因为弱引用 没有拷贝到堆 所以只加一次
        NSLog(@"---%ld",CFGetRetainCount((__bridge CFTypeRef)(objc)));
    };
    weakBlock();
    
    //堆block
    void(^mallocBlock)(void) = [weakBlock copy];//+1 weakBlock从栈拷贝到堆
    mallocBlock();
    
}

#pragma mark - 内存拷贝的理解
- (void)blockDemo1{
    int a = 0;
    //栈block
    void(^ __weak weakBlock)(void) = ^{
        NSLog(@"-----%d", a);
    };
    struct _LGBlock *blc = (__bridge struct _LGBlock *)weakBlock;
  
    // 深浅拷贝
    id __strong strongBlock = [weakBlock copy];//栈拷贝到堆
    blc->invoke = nil;
    void(^strongBlock1)(void) = strongBlock;
    strongBlock1(); // 因为blc->invoke 置为了 nil，函数调用为空 调用会崩溃 所以在置为nil之前copy
}

#pragma mark - block 堆栈释放差异
- (void)blockDemo3{
    // 压栈 内存平移
    int a = 0;
    void(^__weak block1)(void) = nil;
    {
        //block2生命周期在作用空间，//block2是栈block，出了作用域（blockDemo3整个方法）会释放
        // __weak 栈区
        //如果不加__weak 是堆区block，出了作用域（最近的大括号），就会置nil，调用会崩溃。
        void(^__weak block2)(void) = ^{
            NSLog(@"---%d", a);
        };
        block1 = block2;//指针拷贝
        NSLog(@"1 - %@ - %@",block1,block2);
    }
    block1();
}

#pragma mark - 循环引用
//方法1 weak strong强弱共舞
- (void)test1
{
        //解决方式。weak strong dance（强弱共舞解决方法）
        __weak typeof(self) weakSelf = self;
        self.block = ^{
    //        NSLog(@"%@",weakSelf);
            //里面代码复杂的情况。里面有异步 耗时操作
            //延长生命周期，为了在block执行完成之前，self不会被释放。因为strongSelf是局部变量，在block执行结束后会释放，所以不会造成循环引用。
            //同样引用计数会加1，延长生命周期，但是strong作用域是在block代码块里面，代码块执行完之后strong修饰的self也会被回收，引用计数恢复正常。
            __strong typeof(weakSelf) strongSelf = weakSelf; //strongSelf 引用计数加1 局部变量，block执行完之后就回归正常没有了
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //NSLog(@"%@",weakSelf.name);
                /**
                 这种情况 直接返回了 会走当前控制器的dealloc方法，但是2秒后打印的name是null。
                 这种情况下 如果是异步请求，数据就会丢失，还浪费带宽。 虽然也走dealloc 没有循环引用。
                 过早的释放
                 */
                
                NSLog(@"%@",strongSelf.name);//weakSelf不会引用计数加1 strongSelf会，执行完这块代码块之后，就会release。
                /**
                 这种情况 会等到执行完打印name 然后再走dealloc。
                 */
            });
        };
        self.block();
}

//方法2 临时变量
- (void)test2
{
    //第二种解决方式：引用一个临时第三者中间变量objc。objc->nil手动释放
    __block HHBlockViewController *vc = self;//临时变量vc持有
    self.block = ^{
        //        NSLog(@"%@",weakSelf);
        //里面代码复杂的情况。里面有异步 耗时操作
        //延长生命周期
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"%@",vc.name);
            //用完之后 将vc置空
            vc = nil;//self->block->vc->self
        });
    };
}

//方法3 通过传参数
- (void)test3
{
    //循环引用的原因：因为block里面要用self  作用域之间的通讯 self.name在外部，作用空间在block里面的空间。 作用域和作用域之间的传递可以用参数来传递。
    self.block1 = ^(HHBlockViewController *vc){
        //        NSLog(@"%@",weakSelf);
        //里面代码复杂的情况。里面有异步 耗时操作
        //延长生命周期
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"%@",vc.name);
        });
    };
    //可以通过静态分析或者Product的Profile也可以分析
    self.block1(self);
}


# pragma mark weak面试题
- (void)blockWeak_static {
    // 是同一片内存空间 self和weakself指针指向同一个内存空间 但是两个指针的地址不一样
    __weak typeof(self) weakSelf = self;
    staticSelf_ = weakSelf;//会内存泄漏
    // 全局静态变量staticSelf_ -> weakSelf -> self
}

# pragma mark weak_strong_dance
- (void)block_weak_strong {//内存泄漏
    __weak typeof(self) weakSelf = self;
    self.doWork = ^{
        __strong typeof(self) strongSelf = weakSelf;//出了doWork作用域，引用计数会-1
        weakSelf.doStudent = ^{
            NSLog(@"%@", strongSelf);//额外加1 所以需要下面置nil
//            strongSelf = nil;
        };
       weakSelf.doStudent();
    };
   self.doWork();
}

- (void)partValue {
    int a = 100;
    void(^block)() = ^{
        NSLog(@"%d",a);//打印100
//        a = 300;//编译会报错
    };
    a = 200;
    block();
}

- (void)staticValue {
    static int a = 100;
    void(^block)() = ^{
        a += 100;
        NSLog(@"%d",a);//打印100
//        a = 300;//编译会报错
    };
    a = 200;
    block();
}

- (void)testBlockFunc {
    int (^testBlock)(int) = ^(int num) {
        return num++;//返回的是num，因为先返回num，后++。
    };
    int a = testBlock(3);
    int b = testBlock(a);
    int c = testBlock(b);
    NSLog(@"testBlock_num:%d", testBlock(testBlock(testBlock(3))));
}

- (void)dealloc{
    NSLog(@"dealloc 来了");
}

@end
