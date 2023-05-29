//
//  NSObject+MethodSwizzling.h
//  HHRuntime
//
//  Created by michael on 2021/7/23.
//  Copyright © 2021 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MethodSwizzling)

+ (BOOL)hh_hookWithClass:(Class)class
origInstanceMenthod:(SEL)origSel
newInstanceMenthod:(SEL)newSel;

@end

NS_ASSUME_NONNULL_END
