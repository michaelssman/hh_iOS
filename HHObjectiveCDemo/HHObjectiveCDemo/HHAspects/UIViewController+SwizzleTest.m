//
//  UIViewController+SwizzleTest.m
//  HHAspectsDemo
//
//  Created by Michael on 2020/9/9.
//  Copyright © 2020 michael. All rights reserved.
//

#import "UIViewController+SwizzleTest.h"
#import "Aspects.h"
#import <objc/runtime.h>
@implementation UIViewController (SwizzleTest)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换viewWillAppear。只交换了block
        //生命周期：直接把viewWillAppear方法替换掉，还是在原有方法之前执行，或者是之后执行。
        //AspectPositionAfter 在viewWillAppear之后执行
        //怎么hook block
        //把viewWillAppear和block做一个绑定
        //IMP 方法签名v@:对应上
        //校验方法签名信息

        /**
         block转换成自定义结构体，通过结构体拿到block签名信息
         */
        [UIViewController aspect_hookSelector:@selector(loadView) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
            UIViewController *vc = (UIViewController *)aspectInfo.instance;
            vc.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];;
        } error:nil];
    
        
        
        
        ///AOP 埋点
        ///记录某个页面的停留时间：
        Method method1 = class_getInstanceMethod(self.class, @selector(viewWillAppear:));
        Method method2 = class_getInstanceMethod(self.class, @selector(aopviewWillAppear:));
        method_exchangeImplementations(method1, method2);
    });

    //runtime 交换 imp
}

- (void)aopviewWillAppear:(BOOL)animated {
    NSLog(@"埋点%@",self.class);
    [self aopviewWillAppear:animated];
}

@end
