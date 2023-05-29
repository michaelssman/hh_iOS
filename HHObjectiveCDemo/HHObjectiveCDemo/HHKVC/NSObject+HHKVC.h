//
//  NSObject+HHKVC.h
//  HHKVC
//
//  Created by michael on 2021/8/3.
//  Copyright © 2021 michael. All rights reserved.
//  自定义KVC流程

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HHKVC)

// LG KVC 自定义入口
- (void)lg_setValue:(nullable id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
