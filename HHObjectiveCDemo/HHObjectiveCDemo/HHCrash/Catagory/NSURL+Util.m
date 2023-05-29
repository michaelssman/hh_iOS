//
//  NSURL+Util.m
//  HHCrash
//
//  Created by Michael on 2020/11/20.
//  Copyright © 2020 michael. All rights reserved.
//

#import "NSURL+Util.h"
#import "NSObject+MethodSwizzling.h"

@implementation NSURL (Util)

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
        [self hh_hookWithClass:object_getClass(self) origInstanceMenthod:@selector(URLWithString:) newInstanceMenthod:@selector(hh_URLWithString:)];
    });
}

//string是NSNULL
+ (instancetype)hh_URLWithString:(id)string
{
    if ([string isKindOfClass:[NSString class]]) {
        return [self hh_URLWithString:string];
    } else {
        return [self hh_URLWithString:@""];
    }
}

@end
