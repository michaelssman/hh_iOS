//
//  UIView+HHAnimation.h
//  HHAnimationDemo
//
//  Created by FN-116 on 2021/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    TZOscillatoryAnimationToBigger,
    TZOscillatoryAnimationToSmaller,
} TZOscillatoryAnimationType;
@interface UIView (HHAnimation)<CAAnimationDelegate>

/// 弹簧动画
/// @param layer 需要放大（缩小）动画的View的layer
/// @param type <#type description#>
+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(TZOscillatoryAnimationType)type;

/// 缩放
- (void)keyFrameAnimation;

/// 透明度
- (void)alphaAnimation;

/// 先上移放大组动画 上移放大组动画结束之后 震荡动画
- (void)scaleForeverAnimation;

@end

NS_ASSUME_NONNULL_END
