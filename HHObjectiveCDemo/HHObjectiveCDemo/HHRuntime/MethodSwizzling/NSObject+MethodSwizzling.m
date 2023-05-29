//
//  NSObject+MethodSwizzling.m
//  HHRuntime
//
//  Created by michael on 2021/7/23.
//  Copyright © 2021 michael. All rights reserved.
//

#import "NSObject+MethodSwizzling.h"

@implementation NSObject (MethodSwizzling)

+ (BOOL)hh_hookWithClass:(Class)class
     origInstanceMenthod:(SEL)origSel
      newInstanceMenthod:(SEL)newSel
{
    //    Class class = NSClassFromString(@"__NSArrayI");
    if (!class) {
        NSLog(@"传入的交换类不能为空");
        return NO;
    }
    //    Class class = NSClassFromString(@"__NSArrayI");
    Method origMethod = class_getInstanceMethod(class, origSel);//原始方法可能没有实现
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!newMethod) {
        NSLog(@"SEL不能为空");
        return NO;
    }
    if (!origMethod) { // 避免动作没有意义
        // 在oriMethod为nil时，替换后将swizzledSEL复制一个不做任何事的空实现,代码如下:
        class_addMethod(class, origSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        method_setImplementation(newMethod, imp_implementationWithBlock(^(id self, SEL _cmd){
            NSLog(@"来了一个空的 imp");
            //里面可以添加埋点 处理
        }));
    }
    /**
     // 一般交换方法: 交换自己有的方法 -- 走下面 因为自己有意味添加方法失败
     // 交换自己没有实现的方法:
     //   首先第一步:会先尝试给自己添加要交换的方法 :personInstanceMethod (SEL) -> swiMethod(IMP)
     //   然后再将父类的IMP给swizzle  personInstanceMethod(imp) -> swizzledSEL
     //oriSEL:personInstanceMethod
     */
    //先判断方法有没有实现 子类没有实现
    //子类中没有该方法 父类中有该方法，把父类中的该方法交换了，父类使用的时候找不到子类交换的那个方法。父类中没有子类中交换后的方法，此时子类就影响了父类。
    //所以给子类添加一个该方法
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(newMethod), method_getTypeEncoding(origMethod));
    //如果已经添加成功了。就直接替换方法的实现
    if (didAddMethod) {// 自己没有 - 替换 - 没有父类进行处理 (重写一个)
        class_replaceMethod(class, newSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {// 自己有 交换方法实现
        method_exchangeImplementations(origMethod, newMethod);
    }
    return YES;
}

@end
