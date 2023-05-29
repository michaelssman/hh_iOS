//
//  DrawTrianglePath.h
//  DrawDemo
//
//  Created by Michael on 2019/12/5.
//  Copyright © 2019 michael. All rights reserved.
//  画三角形

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawTrianglePath : NSObject

/// <#Description#>
/// @param rect <#rect description#>
/// @param cornerRadius <#cornerRadius description#>
/// @param backgroundColor 背景色
/// @param arrowWidth <#arrowWidth description#>
/// @param arrowHeight <#arrowHeight description#>
/// @param arrowPosition <#arrowPosition description#>
+ (CAShapeLayer *)hh_maskLayerWithRect:(CGRect)rect
                          cornerRadius:(CGFloat)cornerRadius
                       backgroundColor:(UIColor *)backgroundColor
                            arrowWidth:(CGFloat)arrowWidth
                           arrowHeight:(CGFloat)arrowHeight
                         arrowPosition:(CGFloat)arrowPosition;

/// <#Description#>
/// @param rect <#rect description#>
/// @param cornerRadius <#cornerRadius description#>
/// @param borderWidth <#borderWidth description#>
/// @param borderColor <#borderColor description#>
/// @param backgroundColor <#backgroundColor description#>
/// @param arrowWidth 三角形的宽
/// @param arrowHeight 三角形的高
/// @param arrowPosition 三角形左下角的x
+ (UIBezierPath *)hh_bezierPathWithRect:(CGRect)rect
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
                        backgroundColor:(UIColor *)backgroundColor
                             arrowWidth:(CGFloat)arrowWidth
                            arrowHeight:(CGFloat)arrowHeight
                          arrowPosition:(CGFloat)arrowPosition;

@end

NS_ASSUME_NONNULL_END
