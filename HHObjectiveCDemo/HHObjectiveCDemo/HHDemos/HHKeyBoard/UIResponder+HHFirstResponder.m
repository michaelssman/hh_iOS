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
    /**
     当target参数为nil时，sendAction:to:from:forEvent:方法会尝试将动作消息发送给响应者链中的第一个响应者，而不指定特定的目标对象。

     在这种情况下，系统会沿着响应者链向上搜索，直到找到能够响应该动作消息的对象。通常情况下，响应者链的起点是当前视图或视图控制器。

     如果找到能够响应该动作消息的对象，系统将调用其对应的方法来处理该动作。这可以用于实现一些通用的动作，例如在视图层次结构中找到第一个能够处理特定动作的对象，并将该动作传递给它。

     需要注意的是，如果没有找到能够响应该动作消息的对象，或者目标对象不支持指定的动作方法，该方法将返回NO，表示消息发送失败。
     
     当sender参数为nil时，sendAction:to:from:forEvent:方法会将动作消息发送给目标对象，但不会传递发送者对象的信息。

     通常情况下，sender参数用于标识触发该动作消息的对象，例如按钮控件。通过传递sender对象，目标对象可以获取关于发送者的相关信息，例如按钮的状态或标识符。

     如果将sender参数设置为nil，目标对象将无法获取关于发送者的信息，可能会导致在处理动作时缺少某些上下文。这种情况下，目标对象需要从其他途径获取所需的上下文信息，或者在实现动作方法时不依赖于发送者对象的信息。

     需要注意的是，如果目标对象的动作方法不依赖于发送者对象的信息，或者在该方法中可以处理缺少发送者信息的情况，那么将sender参数设置为nil并不会影响动作的处理。

     */
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
