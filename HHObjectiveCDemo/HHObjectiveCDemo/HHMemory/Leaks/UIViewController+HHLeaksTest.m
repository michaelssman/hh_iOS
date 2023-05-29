//
//  UIViewController+HHLeaksTest.m
//  HHMemoryDemo
//
//  Created by Michael on 2020/8/23.
//  Copyright © 2020 michael. All rights reserved.
//

#import "UIViewController+HHLeaksTest.h"
#import <objc/runtime.h>
#import "NSObject+HHSwizzling.h"
#import "NSObject+MethodSwizzling.h"

const char *HHVCFLAG = "HHVCFLAG";

@implementation UIViewController (HHLeaksTest)

/// 交换方法
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hh_hookWithClass:object_getClass(self) origInstanceMenthod:@selector(viewWillAppear:) newInstanceMenthod:@selector(hh_viewWillAppear:)];
        [self hh_hookWithClass:object_getClass(self) origInstanceMenthod:@selector(viewDidDisappear:) newInstanceMenthod:@selector(hh_viewDidDisappear:)];
        
        [self hh_hookWithClass:object_getClass(self) origInstanceMenthod:@selector(dismissViewControllerAnimated:completion:) newInstanceMenthod:@selector(hh_dismissViewControllerAnimated:completion:)];
    });
}

- (void)hh_viewWillAppear:(BOOL)animated
{
    [self hh_viewWillAppear:animated];
    objc_setAssociatedObject(self, HHVCFLAG, @(NO), OBJC_ASSOCIATION_ASSIGN);
}

- (void)hh_viewDidDisappear:(BOOL)animated
{
    [self hh_viewDidDisappear:animated];
    if ([objc_getAssociatedObject(self, HHVCFLAG) boolValue]) {
        //如果是yes就是pop
        //pop出去之后 是否还存活
        //已经出栈了。监听是否释放
        [self willDealloc];
    }
}

- (void)hh_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self hh_dismissViewControllerAnimated:flag completion:completion];
    [self willDealloc];
}
@end
