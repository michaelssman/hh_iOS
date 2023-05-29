//
//  block1.c
//  HHBlock
//
//  Created by Michael on 2020/8/7.
//  Copyright © 2020 michael. All rights reserved.
//  捕获外界变量

#include <stdio.h>

int main1(){
//    int a = 10;
    //如果要修改a的值 要在前面加__block
    __block int a = 10;
    void(^block)(void) = ^{
        a++;//如果int a不加__block修饰，但是在里面修改a的值，但是里面的a和外面的a不是同一个a，所以就会代码歧义，报错。加了__block就是指针拷贝。同一内存空间。编码也能通过。
        printf("Hello hh - %d",a);
    };
    
    block();
    return 0;
}

/**
 int main1(){
     int a = 10;
 //比之前多个一个参数a  3个参数
     void(*block)(void) = (__main1_block_impl_0(__main1_block_func_0, &__main1_block_desc_0_DATA, a));

     ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
     return 0;
 }
 //a就传到了__main1_block_impl_0里面
 struct __main1_block_impl_0 {
   struct __block_impl impl;
   struct __main1_block_desc_0* Desc;
   int a; //成员变量a
   __main1_block_impl_0(void *fp, struct __main1_block_desc_0 *desc, int _a, int flags=0) : a(_a) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
   }
 };
 
 //block代码块
 static void __main1_block_func_0(struct __main1_block_impl_0 *__cself) {
 int a = __cself->a; // bound by copy   生成了一个新的变量a。  值拷贝

       printf("Hello hh - %d",a);
   }
 */
//block捕获外界变量，会根据外界变量编译的时候自动生成相应的成员变量。
//block把a的值传了进去，里面生成了一个新的变量a。







//如果要修改a的值 要在前面加__block
//__block原理
/**
 int main1(){

 //__block修饰的变量
 //先声明一个a 的结构体，对a赋值。结构体a有了外部int a的值和地址空间。
 //对结构体赋值 初始化
 //结构体在堆里。int a在栈，结构体a在堆区。
     __Block_byref_a_0 a = { //假象 拷贝到堆
         (void*)0,
         (__Block_byref_a_0 *)&a, //地址空间
         0,
         sizeof(__Block_byref_a_0),
         10//值
    };
     
     
     void(*block)(void) = ((void (*)())&__main1_block_impl_0((void *)__main1_block_func_0, &__main1_block_desc_0_DATA, (__Block_byref_a_0 *)&a, 570425344));//数字570425344是一个flag
     
     ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
     return 0;
 }
 
 __Block_byref_a_0是一个结构体
 struct __Block_byref_a_0 {
   void *__isa;
 __Block_byref_a_0 *__forwarding;
  int __flags;
  int __size;
  int a;
 };
 
 static void __main1_block_func_0(struct __main1_block_impl_0 *__cself) {
 __Block_byref_a_0 *a = __cself->a; // bound by ref  指针拷贝

       printf("Hello hh - %d",(a->__forwarding->a));
   }
 
 */
