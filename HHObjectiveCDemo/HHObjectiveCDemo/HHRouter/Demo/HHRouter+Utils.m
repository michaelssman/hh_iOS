//
//  HHRouter+Utils.m
//  HHRouter
//
//  Created by michael on 2021/5/18.
//  Copyright © 2021 michael. All rights reserved.
//

#import "HHRouter+NewsActions.h"
// ******************** NOTE  ************************

//TODO: 这里的两个字符串必须 hard code

//  1. 字符串 是类名 OCTarget_xxx.h 中的 xxx 部分
NSString * const kCTMediatorTarget_News = @"News";

//  2. 字符串是 OCTarget_xxx.h 中 定义的 action_xxxx 函数名的 xxx 部分
NSString * const kCTMediatorActionNativTo_NewsViewController = @"NativeToNewsViewController";

// ******************** NOTE  ************************

@implementation HHRouter (Utils)

- (UIViewController *)hhRouter_newsViewControllerWithParams:(NSDictionary *)dict callBlock:(nonnull void (^)(NSString * _Nonnull))callBlock
{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (callBlock) {
        parameters[@"callBlock"] = callBlock;
    }
    
    UIViewController *viewController = [self performTarget:kCTMediatorTarget_News
                                                    action:kCTMediatorActionNativTo_NewsViewController
                                                    param:parameters];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        NSLog(@"%@ 未能实例化页面", NSStringFromSelector(_cmd));
        return [[UIViewController alloc] init];
    }
}

@end
