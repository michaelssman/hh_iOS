//
//  NSObject+HHKVO.h
//  KVODemo
//
//  Created by Michael on 2020/8/5.
//  Copyright © 2020 michael. All rights reserved.
//

//kvo任意类行都可以调，所以自定义KVO在NSObject的分类里。
/**
 函数式编程：把函数当成参数传递。
 y = f(x) -> y = f(f(x))
 参数(函数) - 函数 - block
 
 响应式：你变我就变
 */

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^HHKVOBlock)(id observer,NSString *keyPath,id oldValue,id newValue);

typedef NS_OPTIONS(NSUInteger, HHKeyValueObservingOptions) {

    HHKeyValueObservingOptionNew = 0x01,
    HHKeyValueObservingOptionOld = 0x02,
};

@interface HHKVOInfo : NSObject
@property (nonatomic, weak) NSObject  *observer;//使用weak
@property (nonatomic, copy) NSString    *keyPath;
@property (nonatomic, assign) HHKeyValueObservingOptions options;
@property (nonatomic, copy) HHKVOBlock  handleBlock;

- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(HHKeyValueObservingOptions)options handleBlock:(HHKVOBlock)block;

@end

@interface NSObject (HHKVO)
- (void)hh_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(HHKeyValueObservingOptions)options block:(HHKVOBlock)block;

//观察者回调方法
- (void)hh_observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context;

- (void)hh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

/**
 观察多个值：
 观察新值旧值：
 自动销毁：
 动态子类添加dealloc方法，是重写，和HHPerson类没有关系。
 */
@end

NS_ASSUME_NONNULL_END
