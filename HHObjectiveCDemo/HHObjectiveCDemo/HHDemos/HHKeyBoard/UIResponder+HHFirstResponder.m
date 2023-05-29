//
//  UIResponder+HHFirstResponder.m
//  HHKeyboard
//
//  Created by Michael on 2020/6/17.
//  Copyright © 2020 michael. All rights reserved.
//

#import "UIResponder+HHFirstResponder.h"

@implementation UIResponder (HHFirstResponder)
static __weak id hh_currentFirstResponder;

+ (void)inputText:(NSString *)text
{
    UIView <UITextInput> *textInput = [UIResponder firstResponderTextView];
    NSString *character = [NSString stringWithString:text];
    
    BOOL canEditor = YES;
    if ([textInput isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)textInput;
        if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            canEditor = [textField.delegate textField:textField shouldChangeCharactersInRange:NSMakeRange(textField.text.length, 0) replacementString:character];
        }
        
        if (canEditor) {
            [textField replaceRange:textField.selectedTextRange withText:text];
        }
    }
    else if ([textInput isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)textInput;
        if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            canEditor = [textView.delegate textView:textView shouldChangeTextInRange:NSMakeRange(textView.text.length, 0) replacementText:character];
        }
        
        if (canEditor) {
            [textView replaceRange:textView.selectedTextRange withText:text];
        }
    }
}

+ (void)hh_deleteBackward
{
    UIView <UITextInput> *textInput = [UIResponder firstResponderTextView];
    [textInput deleteBackward];
}

+ (UIView <UITextInput> *)firstResponderTextView
{
    UIView <UITextInput> *textInput = (UIView <UITextInput> *)[UIResponder hh_currentFirstResponder];
    
    if ([textInput conformsToProtocol:@protocol(UIKeyInput)]) {
        return textInput;
    }
    return nil;
}

/// 获取第一响应者：
/// - (BOOL)sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(nullable UIEvent *)event;
+ (UIResponder *)hh_currentFirstResponder {
    hh_currentFirstResponder = nil;
    // 通过将target设置为nil，让系统自动遍历响应链
    // 从而响应链当前第一响应者响应我们自定义的方法
    [[UIApplication sharedApplication] sendAction:@selector(findHHTradeFirstResponder:) to:nil from:nil forEvent:nil];
    
    return hh_currentFirstResponder;
}
// 对象方法 调用的是上面的类方法
- (UIResponder *)hh_currentFirstResponder {
    return [[self class] hh_currentFirstResponder];
}

- (void)findHHTradeFirstResponder:(id)sender {
    // 第一响应者会响应这个方法，并且将静态变量hh_currentFirstResponder设置为自己
    NSLog(@"firstresponder:%@",self);
    hh_currentFirstResponder = self;
}
@end
