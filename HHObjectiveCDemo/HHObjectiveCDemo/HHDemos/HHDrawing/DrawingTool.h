//
//  DrawingTool.h
//  DrawingRound
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrawingTool : NSObject
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *voice;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;
- (void)draw;
- (void)drawCircle;

//上传的数据
- (NSDictionary *)getJsonWithWidth:(CGFloat) width
                            height:(CGFloat) height;
//请求到的数据处理
- (void)MarkNodeWithData:(NSDictionary *) objData
                   width:(CGFloat) width
                  height:(CGFloat) height;
@end
