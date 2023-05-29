//
//  UIResponder+HHFirstResponder.h
//  HHKeyboard
//
//  Created by Michael on 2020/6/17.
//  Copyright © 2020 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (HHFirstResponder)
+ (void)inputText:(NSString *)text;
+ (void)hh_deleteBackward;

/// 获取第一响应者：
/// - (BOOL)sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(nullable UIEvent *)event;
+ (UIResponder *)hh_currentFirstResponder;
@end

NS_ASSUME_NONNULL_END
