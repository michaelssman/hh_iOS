//
//  DrawingTool.m
//  DrawingRound
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DrawingTool.h"

#pragma mark - DrawingRectTool

@implementation DrawingTool

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.firstPoint = startPoint;
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the rectangle
    CGRect rectToFill = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextStrokeRect(UIGraphicsGetCurrentContext(), rectToFill);
}

#pragma mark 画圆
- (void)drawCircle
{
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.描述路径
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.firstPoint.x - self.radius, self.firstPoint.y - self.radius, self.radius * 2, self.radius * 2)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.firstPoint.x - self.radius, self.lastPoint.y - self.radius, self.radius * 2, self.radius * 2)];
    UIBezierPath *path3 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.lastPoint.x - self.radius, self.firstPoint.y - self.radius, self.radius * 2, self.radius * 2)];
    UIBezierPath *path4 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.lastPoint.x - self.radius, self.lastPoint.y - self.radius, self.radius * 2, self.radius * 2)];
    [path1 fill];
    [path2 fill];
    [path3 fill];
    [path4 fill];
    [[UIColor blueColor] set];
    // 3.将路径添加到上下文
    CGContextAddPath(ctx, path1.CGPath);
    CGContextAddPath(ctx, path2.CGPath);
    CGContextAddPath(ctx, path3.CGPath);
    CGContextAddPath(ctx, path4.CGPath);

    // 4.将上下文渲染到视图
    CGContextFillPath(ctx);
    
}
#pragma mark dealWithData
- (NSDictionary *)getJsonWithWidth:(CGFloat)width height:(CGFloat)height {
    NSDictionary *objData = @{@"start_x" : @(self.firstPoint.x / width),
                              @"start_y" : @(self.firstPoint.y / height),
                              @"end_x" : @(self.lastPoint.x / width),
                              @"end_y" : @(self.lastPoint.y / height),
                              @"text" : self.text,
                              @"voice" : self.voice};
    return objData;
}
- (void)MarkNodeWithData:(NSDictionary *)objData width:(CGFloat)width height:(CGFloat)height {
    
}
@end
