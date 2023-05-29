//
//  UINavigationController+HHLeaksTest.m
//  HHMemoryDemo
//
//  Created by Michael on 2020/8/23.
//  Copyright © 2020 michael. All rights reserved.
//

#import "UINavigationController+HHLeaksTest.h"
#import <objc/runtime.h>
#import "NSObject+HHSwizzling.h"
#import "NSObject+MethodSwizzling.h"

@implementation UINavigationController (HHLeaksTest)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hh_hookWithClass:object_getClass(self) origInstanceMenthod:@selector(popViewControllerAnimated:) newInstanceMenthod:@selector(hh_popViewControllerAnimated:)];
    });
}
- (UIViewController *)hh_popViewControllerAnimated:(BOOL)animated
{
   UIViewController *popVC = [self hh_popViewControllerAnimated:animated];
    extern const char *HHVCFLAG;//声明
    objc_setAssociatedObject(popVC, HHVCFLAG, @(YES), OBJC_ASSOCIATION_ASSIGN);
    return popVC;
}
@end
