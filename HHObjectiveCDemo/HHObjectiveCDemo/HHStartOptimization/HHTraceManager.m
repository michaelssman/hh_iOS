//
//  HHTraceManager.m
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2021/12/31.
//

/**
 Clang 的编译器插桩生成的函数。它是在程序启动时自动调用的，用于初始化 Sanitizer Coverage 中的 PC guard，以便记录程序执行过程中哪些代码块被执行过。 包括OC方法， C++函数，block，load，构造方法initialize。

 编译器会自动在代码中插入一些函数调用，包括 __sanitizer_cov_trace_pc_guard_init 和 __sanitizer_cov_trace_pc_guard。
 */

#import "HHTraceManager.h"
#include <stdint.h>
#include <stdio.h>
#include <sanitizer/coverage_interface.h>
#import <dlfcn.h>
#import <libkern/OSAtomic.h>//线程安全
@implementation HHTraceManager
//定义原子队列（线程安全）
static OSQueueHead symbolList = OS_ATOMIC_QUEUE_INIT;
//定义符号结构体
typedef struct {
    void * pc;//符号地址
    void * next;//下一个地址
} SYNode;


#pragma mark - 必须实现下面两个函数
#pragma mark - 第一个回调
//里面反应了项目中符号的个数！！ start开始 stop结束 不包括stop。
void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                                    uint32_t *stop) {
  static uint64_t N;
  if (start == stop || *start) return;
//  printf("INIT: %p %p\n", start, stop);
  for (uint32_t *x = start; x < stop; x++)
    *x = ++N;
}

#pragma mark - 第二个回调
//HOOK一切的回调函数！！
/**
 每次调用load，main，函数，方法，block， 所有的都会拦截。属性的set get方法也会拦截。
 顺序就是程序启动运行调用的顺序
 系统的 第三方库的 不在mach O文件里的不会hook。
 */
void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    //当前内部返回地址 上个函数内部第一句代码的地址
    void *PC = __builtin_return_address(0);
    
//    Dl_info info;
//    dladdr(PC, &info);
    /**
    typedef struct dl_info {
            const char      *dli_fname;//文件的名字     //Pathname of shared object
            void            *dli_fbase;//文件的地址     // Base address of shared object
            const char      *dli_sname;//函数方法的名字     // Name of nearest symbol
            void            *dli_saddr;//函数方法的地址    // Address of nearest symbol
    } Dl_info;
    */
    
    
    
    //MARK: 保存所有符号信息
    //创建结构体
    SYNode * node = malloc(sizeof(SYNode));
    *node = (SYNode){PC,NULL};
    //结构体入栈
    OSAtomicEnqueue(&symbolList, node, offsetof(SYNode, next));
    
}

//生成order文件！！
-(void)createOrderFile {
    //定义数组
    NSMutableArray<NSString *> * symbleNames = [NSMutableArray array];
    
    while (YES) {//循环体内！进行了拦截！！
        SYNode * node = OSAtomicDequeue(&symbolList, offsetof(SYNode,next));
        
        if (node == NULL) {
            break;
        }
        
        Dl_info info;
        dladdr(node->pc, &info);
        NSString * name = @(info.dli_sname);//转OC字符串
        
        //OC方法 直接存。非OC方法 给函数名称，block都添加 _
        BOOL isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
        NSString * symbolName = isObjc ? name : [@"_" stringByAppendingString:name];
        [symbleNames addObject:symbolName];
          
    }
    //队列是反的 有重复的 OC函数需要加_
    //反向遍历数组
    NSEnumerator * em = [symbleNames reverseObjectEnumerator];
    //定义一个数组，去重使用
    NSMutableArray * funcs = [NSMutableArray arrayWithCapacity:symbleNames.count];
    NSString * name;
    while (name = [em nextObject]) {
        if (![funcs containsObject:name]) {//数组没有name
            [funcs addObject:name];
        }
    }
    //去掉自己！
    [funcs removeObject:[NSString stringWithFormat:@"%s",__func__]];
    
    //写入文件
    //1.变成字符串
    NSString * funcStr = [funcs componentsJoinedByString:@"\n"];
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hank.order"];
    NSData * file = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:file attributes:nil];
    
    NSLog(@"order地址：%@",filePath);
}
@end
