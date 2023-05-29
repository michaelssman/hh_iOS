//
//  NSObject+HHSwizzling.h
//  HHMemoryDemo
//
//  Created by Michael on 2020/8/23.
//  Copyright © 2020 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HHSwizzling)
- (void)willDealloc;
@end

NS_ASSUME_NONNULL_END
