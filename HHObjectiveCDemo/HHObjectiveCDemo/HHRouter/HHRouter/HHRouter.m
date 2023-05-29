//
//  HHRouter.m
//  HHRouter
//
//  Created by Michael on 2020/7/14.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHRouter.h"
#define kClassPrefix    @"OCTarget_"
#define kActionPrefix   @"action_"
@implementation HHRouter

//因为router会经常引用，所以使用单例的方式
+ (instancetype)sharedInstance
{
    static HHRouter *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[HHRouter alloc]init];
    });
    return mediator;
}

// http://Index/home?name=zhangsan&pws=123
// 把url进行切割，
- (id)openUrl:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    
    //查询 返回链接地址问号之后的参数字符串
    NSString *paramsString = [url query];//params
    //切割字符串。循环参数
    for (NSString *param in [paramsString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if ([elts count] < 2) continue;
        id firstEle = [elts firstObject];
        id lastEle = [elts lastObject];
        if (firstEle && lastEle) {
            [paramsDic setObject:lastEle forKey:firstEle];
        }
    }
    
    // 拿到url http://Index/home?name=zhangsan&pws=123中的home
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    //响应
    id result = [self performTarget:url.host action:actionName param:paramsDic];
    return result;
}

// 调targetName类里面的actionName方法 参数是para
// 通过字符串形式 字符串在上面的方法中已经切割好了。
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName param:(NSDictionary *)para
{
    // 这个目标的类名字符串
    NSString *targetClassString = [NSString stringWithFormat:@"%@%@",kClassPrefix,targetName];
    Class targetClass = NSClassFromString(targetClassString);
    NSObject *target = [[targetClass alloc]init];
    
    NSString *actionString = [NSString stringWithFormat:@"%@%@:",kActionPrefix,actionName];
    SEL action = NSSelectorFromString(actionString);
    
    //判断
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target param:para];
    } else {
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target param:para];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            return nil;
        }
    }
    
    return nil;
}

/**
 1. 通过对象调用指定的方法
 2. 传参
 */
- (id)safePerformAction:(SEL)action target:(NSObject *)target param:(NSDictionary *)para
{
    //拿到方法的签名
    NSMethodSignature *methodSig = [target methodSignatureForSelector:action];
    
    if (methodSig == nil) {
        return nil;
    }
    
    //获取这个方法返回值的地址
    const char *retType = [methodSig methodReturnType];
    
    //id 是可以返回任意对象 所以 我们单独处理基本变量，NSInteger BOOL void ...
    // 不是对象的情况处理
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        // 为什么传2 前面的0和1这两个位置已经被target和action给占用了，隐式参数。
        [invocation setArgument:&para atIndex:2];
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];
        return nil;
    }
    else if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&para atIndex:2];
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];//调用
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);//返回参数
    }
    else if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&para atIndex:2];
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:para];
#pragma clang diagnostic pop
}

//每一个方法都会有一个地址

@end
