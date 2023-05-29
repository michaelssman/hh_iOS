//
//  NSArray+HHCrash.m
//  HHCrash
//
//  Created by Michael on 2020/7/29.
//  Copyright © 2020 michael. All rights reserved.
//

#import "NSArray+HHCrash.h"
#import "NSObject+MethodSwizzling.h"

@implementation NSArray (HHCrash)
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
        [self hh_hookWithClass:objc_getClass("__NSArrayI") origInstanceMenthod:@selector(objectAtIndexedSubscript:) newInstanceMenthod:@selector(hh_objectAtIndexedSubscript:)];
        [self hh_hookWithClass:objc_getClass("__NSSingleObjectArrayI") origInstanceMenthod:@selector(objectAtIndex:) newInstanceMenthod:@selector(hh_objectAtIndex:)];

        [self hh_hookWithClass:object_getClass(self) origInstanceMenthod:@selector(arrayWithArray:) newInstanceMenthod:@selector(hh_arrayWithArray:)];
    });
}

//数组越界
- (id)hh_objectAtIndexedSubscript:(NSUInteger)index
{
    if (index < self.count) {
        return [self hh_objectAtIndexedSubscript:index];//imp指向的是原来系统的方法
    }
    //可以加一些处理：返回到首页 或者pop出去。
    return nil;
}
- (id)hh_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self hh_objectAtIndex:index];
    }
    return nil;
}

//后台返回的data应该是数组但不是数组
+ (instancetype)hh_arrayWithArray:(id)array
{
    if ([array isKindOfClass:[NSArray class]]) {
        return [self hh_arrayWithArray:array];
    } else {
        return [NSArray array];
    }
}

@end
