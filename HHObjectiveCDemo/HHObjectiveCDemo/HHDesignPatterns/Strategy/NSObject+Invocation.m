//
//  NSObject+Invocation.m
//  HHDesignPatterns
//
//  Created by Michael on 2020/8/25.
//  Copyright © 2020 michael. All rights reserved.
//

#import "NSObject+Invocation.h"

@implementation NSObject (Invocation)
- (id)invocationWithSelector:(SEL)selector
{
    return [self invocationWithSelector:selector withObjects:nil];
}

/**
 将复杂的逻辑包装成invocation。
 NSInvocation：用来包装方法和对应的对象，它可以存储方法的名称，对应的对象，对应的参数,
 */
- (id)invocationWithSelector:(SEL)selector withObjects:(NSArray *)objects
{
    /*
     NSMethodSignature：签名：创建NSMethodSignature的时候，必须传递一个签名对象
     签名对象的作用：用于获取参数的个数和方法的返回值
     创建签名对象的时候不是使用NSMethodSignature这个类创建，而是方法属于谁就用谁来创建
     */
    //1、创建签名对象
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
    
    //2.判断传入的方法是否存在
    if (methodSignature == nil) {
        //传入的方法不存在 就抛异常
        NSString*info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(selector)];
        @throw [[NSException alloc] initWithName:@"方法没有" reason:info userInfo:nil];
        return nil;
    }
    
    //3.创建NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = self;
    //invocation中的方法必须和签名中的方法一致。
    invocation.selector = selector;
    
    //5、设置参数
    /*
     当前如果直接遍历参数数组来设置参数
     如果参数数组元素多余参数个数，那么就会报错
     */
    NSInteger arguments = methodSignature.numberOfArguments - 2;
    /*
     如果直接遍历参数的个数，会存在问题
     如果参数的个数大于了参数值的个数，那么数组会越界
     谁少就遍历谁
     */
    NSInteger count = MIN(arguments, objects.count);
    for (int i = 0; i<count; i++) {
        NSObject*obj = objects[i];
        //处理参数是NULL类型的情况
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        [invocation setArgument:&obj atIndex:i+2];
    }
//    //6、调用NSinvocation对象
//    [invocation invoke];
//    //7、获取返回值
//    id res = nil;
//    //判断当前方法是否有返回值
//    //    NSLog(@"methodReturnType = %s",signature.methodReturnType);
//    //    NSLog(@"methodReturnTypeLength = %zd",signature.methodReturnLength);
//    if (signature.methodReturnLength!=0) {
//        //getReturnValue获取返回值
//        [invocation getReturnValue:&res];
//    }
    return invocation;
}
@end
