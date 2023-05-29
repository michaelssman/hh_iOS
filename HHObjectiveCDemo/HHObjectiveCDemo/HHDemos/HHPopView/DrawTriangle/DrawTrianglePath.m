//
//  DrawTrianglePath.m
//  DrawDemo
//
//  Created by Michael on 2019/12/5.
//  Copyright © 2019 michael. All rights reserved.
//

#import "DrawTrianglePath.h"

@implementation DrawTrianglePath
+ (CAShapeLayer *)hh_maskLayerWithRect:(CGRect)rect
                          cornerRadius:(CGFloat)cornerRadius
                       backgroundColor:(nonnull UIColor *)backgroundColor
                            arrowWidth:(CGFloat)arrowWidth
                           arrowHeight:(CGFloat)arrowHeight
                         arrowPosition:(CGFloat)arrowPosition
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [self hh_bezierPathWithRect:rect cornerRadius:cornerRadius borderWidth:0 borderColor:[UIColor blueColor] backgroundColor:backgroundColor arrowWidth:arrowWidth arrowHeight:arrowHeight arrowPosition:arrowPosition].CGPath;
    shapeLayer.strokeColor = backgroundColor.CGColor;
    shapeLayer.fillColor = backgroundColor.CGColor;
    return shapeLayer;
}
+ (UIBezierPath *)hh_bezierPathWithRect:(CGRect)rect
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
                        backgroundColor:(UIColor *)backgroundColor
                             arrowWidth:(CGFloat)arrowWidth
                            arrowHeight:(CGFloat)arrowHeight
                          arrowPosition:(CGFloat)arrowPosition
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (borderColor) {
        [borderColor setStroke];
    }
    if (backgroundColor) {
        [backgroundColor setFill];
    }
    bezierPath.lineWidth = borderWidth;
    rect = CGRectMake(borderWidth / 2, borderWidth / 2, rect.size.width - borderWidth, rect.size.height - borderWidth);
    //四个角的圆角 圆的半径
    CGFloat topRightRadius = cornerRadius, topLeftRadius = cornerRadius, bottomRightRadius = cornerRadius, bottomLeftRadius = cornerRadius;
    CGPoint topRightArcCenter,topLeftArcCenter,bottomRightArcCenter,bottomLeftArcCenter;
    
    CGFloat rectX = rect.origin.x, rectWidth = rect.size.width, rectHeight = rect.size.height;
    CGFloat rectTop = rect.origin.y;
    //左上角的圆弧圆点坐标
    topLeftArcCenter = CGPointMake(topLeftRadius + rectX, arrowHeight + topLeftRadius + rectX);
    //右上角的圆弧圆点坐标
    topRightArcCenter = CGPointMake(rectWidth - topRightRadius + rectX, arrowHeight + topRightRadius + rectX);
    bottomLeftArcCenter = CGPointMake(bottomLeftRadius + rectX, rectHeight - bottomLeftRadius + rectX);
    bottomRightArcCenter = CGPointMake(rectWidth - bottomRightRadius + rectX, rectHeight - bottomRightRadius + rectX);
    if (arrowPosition < topLeftRadius + arrowWidth / 2) {
        arrowPosition = topLeftRadius + arrowWidth / 2;
    }else if (arrowPosition > rectWidth - topRightRadius - arrowWidth / 2) {
        arrowPosition = rectWidth - topRightRadius - arrowWidth / 2;
    }
    //三角形左下角坐标
    [bezierPath moveToPoint:CGPointMake(arrowPosition - arrowWidth / 2, arrowHeight + rectX)];
    //三角形最上面角的坐标
    [bezierPath addLineToPoint:CGPointMake(arrowPosition, rectTop + rectX)];
    //三角形右下角坐标
    [bezierPath addLineToPoint:CGPointMake(arrowPosition + arrowWidth / 2, arrowHeight + rectX)];
    
    [bezierPath addLineToPoint:CGPointMake(rectWidth - topRightRadius, arrowHeight + rectX)];
    [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
    
    [bezierPath addLineToPoint:CGPointMake(rectWidth + rectX, rectHeight - bottomRightRadius - rectX)];
    [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + rectX, rectHeight + rectX)];
    [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    [bezierPath addLineToPoint:CGPointMake(rectX, arrowHeight + topLeftRadius + rectX)];
    [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
    
    [bezierPath closePath];
    return bezierPath;
}
@end
