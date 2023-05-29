//
//  UIScrollView+HHTab.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/9/3.
//

#import "UIScrollView+HHTab.h"
#import <objc/runtime.h>

@implementation UIScrollView (HHTab)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *methodName = [NSString stringWithFormat:@"%@%@%@%@", @"_", @"notify", @"Did", @"Scroll"];
        SEL originalSel = NSSelectorFromString(methodName);
        SEL swizzledSel = @selector(hh_didScroll);
        
        Method originalMethod = class_getInstanceMethod(self, originalSel);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSel);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)hh_didScroll {
    if (self.hh_didScollHandler) {
        self.hh_didScollHandler(self);
    }
    [self hh_didScroll];
}

- (void)setHh_didScollHandler:(void (^)(UIScrollView * _Nonnull))hh_didScollHandler
{
    objc_setAssociatedObject(self, @selector(hh_didScollHandler), hh_didScollHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIScrollView * _Nonnull))hh_didScollHandler
{
    return objc_getAssociatedObject(self, _cmd);
}
@end
