//
//  HHProxy.m
//  HHRunloop
//
//  Created by Michael on 2020/9/1.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHProxy.h"

@implementation HHProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[HHProxy alloc] initWithTarget:target];
}

#pragma mark - 重定向
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _target;
}

//#pragma mark - 标准转发
////消息转发出去
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
//{
////    //获取方法编号 签名
////    return [self.target methodSignatureForSelector:sel];
//    return [NSObject methodSignatureForSelector:@selector(init)];
//}
//
//- (void)forwardInvocation:(NSInvocation *)invocation
//{
////    //设置执行者
////    [invocation invokeWithTarget:self.target];
//    void *null = NULL;
//    [invocation setReturnValue:&null]; //返回值为nil，给nil发消息不会crash
//}

//方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}
//转发
- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}
@end
