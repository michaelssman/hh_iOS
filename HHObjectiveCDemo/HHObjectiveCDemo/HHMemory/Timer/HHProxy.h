//
//  HHProxy.h
//  HHRunloop
//
//  Created by Michael on 2020/9/1.
//  Copyright © 2020 michael. All rights reserved.
//  借鉴YYImage。用来进行消息重定向 转发

/**
 NSObject寻找方法顺序：本类->父类->动态方法解析-> 消息转发；
 NSproxy顺序：本类->消息转发；
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHProxy : NSProxy

/// target存储到了全局的weak_tables
@property (nonatomic, weak, readonly)id target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
