//
//  OCTarget_News.h
//  HHRouter
//
//  Created by michael on 2021/5/18.
//  Copyright © 2021 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTarget_News : NSObject
/**
 *  返回 NewsViewController 实例
 *
 *  @param params 要传给 NewsViewController 的参数
 */
- (UIViewController *)action_NativeToNewsViewController:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
