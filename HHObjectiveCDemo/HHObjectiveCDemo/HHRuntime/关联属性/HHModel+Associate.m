//
//  HHModel+Associate.m
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2022/1/11.
//

#import "HHModel+Associate.h"
#import <objc/runtime.h>

@implementation HHModel (Associate)

//添加关联对象
/**
 objc_setAssociatedObject的四个参数：
 1.  id object给谁设置关联对象。
 2.  const void *key关联对象唯一的key，获取时会用到。
 3.  id value关联对象。
 4.  objc_AssociationPolicy关联策略
 */
- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//获取关联对象
/**
 objc_getAssociatedObject的两个参数。
 1.  id object获取谁的关联对象。
 2.  const void *key根据这个唯一的key获取关联对象。
 */
- (NSString *)name {
    return objc_getAssociatedObject(self, _cmd);
}

@end
