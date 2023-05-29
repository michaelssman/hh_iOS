//
//  UISwitch+Util.m
//  HHCategorysDemo
//
//  Created by Michael on 2021/1/12.
//  Copyright © 2021 michael. All rights reserved.
//

#import "UISwitch+Util.h"
#import <objc/runtime.h>
#import "NSObject+MethodSwizzling.h"

@implementation UISwitch (Util)
// method-swiling
/**
 方法交换写在load方法里
    因为load主动调用 不需要触发，并且比较早（load_image call load）。但是会影响性能，所以并不是所有的methodSwiling都在这里面。
 */
+ (void)load
{
    //load方法可能调用多次  只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hh_hookWithClass:objc_getClass("UISwitch") origInstanceMenthod:@selector(init) newInstanceMenthod:@selector(hh_init)];
        [self hh_hookWithClass:objc_getClass("UISwitch") origInstanceMenthod:@selector(initWithFrame:) newInstanceMenthod:@selector(hh_initWithFrame:)];
    });
}

- (instancetype)hh_init
{
    [[self hh_init] setUpUI];
    return self;
}
- (instancetype)hh_initWithFrame:(CGRect)frame
{
    [[self hh_initWithFrame:frame] setUpUI];
    return self;
}
- (void)setUpUI
{
    self.onTintColor = [UIColor redColor];
}
@end
