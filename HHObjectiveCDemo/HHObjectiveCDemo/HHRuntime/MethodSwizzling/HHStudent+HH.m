//
//  HHStudent+HH.m
//  HHRuntime
//
//  Created by michael on 2021/8/2.
//  Copyright © 2021 michael. All rights reserved.
//

#import "HHStudent+HH.h"
#import "NSObject+MethodSwizzling.h"
@implementation HHStudent (HH)

// method-swizzling
// 1: 一次性问题 - load - 阻碍启动 - initizl
// 2:

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hh_hookWithClass:self origInstanceMenthod:@selector(personInstanceMethod) newInstanceMenthod:@selector(hh_studentInstanceMethod)];
    });
}

// personInstanceMethod 我需要父类的这个方法的一些东西
// 给你加一个personInstanceMethod 方法
// imp

// 是否递归
- (void)hh_studentInstanceMethod{
    [self hh_studentInstanceMethod]; //hh_studentInstanceMethod -/-> personInstanceMethod
    //父类没有实现personInstanceMethod方法，
    NSLog(@"HHStudent分类添加的hh对象方法:%s",__func__);
}

@end
