//
//  block.c
//  HHBlock
//
//  Created by Michael on 2020/8/7.
//  Copyright © 2020 michael. All rights reserved.
//  原理探究

#include <stdio.h>

int main0(){
    
    void(^block)(void) = ^{
        printf("Hello hh");
    };
    
    block();
    return 0;
}

/**
 进入该文件目录下
 clang -rewrite-objc block.c -o block.cpp进行编译成C++
 在底部找到int main0()函数 三行代码 .cpp的三行代码对应上面的三个代码 定义 调用 和return0.
 block就是__main0_block_impl_0这个函数
 __main0_block_impl_0这个函数就是一个struct
 对象在底层是结构体
 
 */

/*
int main0(){

    //首先去除类型转换的代码
    //__main0_block_impl_0 函数
    //两个参数__main0_block_func_0  __main0_block_desc_0_DATA
    void(*block)(void) = __main0_block_impl_0(__main0_block_func_0, &__main0_block_desc_0_DATA));

    //去除类型强转 简写：block->FuncPtr(block)
    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
    return 0;
}

struct __main0_block_impl_0 {
  struct __block_impl impl;
  struct __main0_block_desc_0* Desc;
    //void *fp就是第一个参数
    //结构体的构造函数
  __main0_block_impl_0(void *fp, struct __main0_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;//栈区的block
    impl.Flags = flags;
    impl.FuncPtr = fp; //编程思想：函数式。先保存 在合适的地方调用，需要的地方调用。
    Desc = desc;
  }
};
 
 //第一个参数__main0_block_func_0就是下面的方法，里面就是block里面的代码 所以block能够保存代码就是因为在底层这样实现保存代码。
 static void __main0_block_func_0(struct __main0_block_impl_0 *__cself) {

     printf("Hello hh");
 }
*/


//什么是函数式
//y = f(x)    ->  y = f(f(x));//函数作为一个参数传进来。



//block在底层 结构体
struct Block_layout {
    void *isa;
    volatile int32_t flags;
    int32_t reserved;
    void (*invoke)(void *, ...);
    //block描述信息     捕获外界信息。有方法签名
    struct Block_descripter_1 *descripter;
};

//block包含
/**
 - isa指针
 - flags 枚举类型
    - BLOCK_HAS_COPY_DISPOSE 捕获外界变量的时候 这个是有值的。
    - BLOCK_HAS_SIGNATURE 签名
    - 方法有签名v@: 普通签名
        - v返回值
        - @对象
        - ：cmd方法编号
    - block也有签名信息
 */
