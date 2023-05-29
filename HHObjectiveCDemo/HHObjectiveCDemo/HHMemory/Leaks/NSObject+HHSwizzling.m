//
//  NSObject+HHSwizzling.m
//  HHMemoryDemo
//
//  Created by Michael on 2020/8/23.
//  Copyright © 2020 michael. All rights reserved.
//

#import "NSObject+HHSwizzling.h"
#import <objc/runtime.h>
@implementation NSObject (HHSwizzling)
- (void)willDealloc
{
#ifdef DEBUG
    //怎么监听是否还存活
    //出栈之后延迟两秒。不为空 说明没有被释放
    __weak typeof(self) weakSelf = self;//避免循环引用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;//在block中强引用 strong勾住当前的self
        NSLog(@"hh_NotDealloc--- %@",NSStringFromClass([strongSelf class]));
    });
#endif
}
@end
