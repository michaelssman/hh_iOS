//
//  Person.m
//  HHRuntime
//
//  Created by Michael on 2020/9/10.
//  Copyright © 2020 michael. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "PersonOne.h"
#import "PersonTwo.h"
@implementation Person

#pragma mark - 第一层
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    //匹配方法
    if (sel == @selector(runTo:)) {
        //动态添加方法
        /**
         1. 哪个类
         2. sel
         3. imp 页码
         4. 方法签名 返回值v代表void  id用@ 方法编号用: 参数是NSString用@
         */
        return class_addMethod(self, sel, (IMP)dynamicMethodIMPRunTo, "v@:@");
        //或者
//        IMP imp = class_getMethodImplementation(self.class, @selector(runTo1:));
//        return class_addMethod(self, sel, imp, "v@:@");
    }
    return [super resolveInstanceMethod:sel];
}
//动态添加的@selector(runTo:)对应的方法实现
static void dynamicMethodIMPRunTo(id self, SEL _cmd, id place)
{
    NSLog(@"dynamicMethodIMPRunTo %@",place);
}
- (void)runTo1:(NSString *)string {
    NSLog(@"%s",__func__);
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(runTo:)) {
        //如果imp找不到 则动态决议 进入了死循环
        IMP imp = class_getMethodImplementation(self.class, @selector(runTo_C_D:));
        return class_addMethod(objc_getMetaClass("Person"), sel, imp, "v@:@");//元类中添加类方法
    }
    return [super resolveClassMethod:sel];
}
+ (void)runTo_C_D:(NSString *)string {
    
}
#pragma mark - 第二层 备用接收者 快速转发
//实例方法
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(runTo:)) {
        //备用接收者
        return [PersonOne new];
    }
    return [super forwardingTargetForSelector:aSelector];
}
//类方法
+ (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(runTo:)) {
        //备用接收者
        return PersonOne.class;
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - 第三层 慢速转发
//1.方法签名：方法的具体信息
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(runTo:)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];
}
//2.消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if (anInvocation.selector == @selector(runTo:)) {
        PersonOne *pOne = [[PersonOne alloc]init];
        PersonTwo *pTwo = [[PersonTwo alloc]init];
        if ([pOne respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:pOne];
        }
        if ([pTwo respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:pTwo];
        }
    } else {
        [super forwardInvocation:anInvocation];
    }
}


#pragma mark - 找不到方法
//最后走到这里，然后crash
- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"找不到方法");
}
@end
