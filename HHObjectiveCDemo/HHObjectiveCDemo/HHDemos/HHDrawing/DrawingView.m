//
//  DrawingView.m
//  DrawingRound
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DrawingView.h"
#import "DrawingTool.h"
#define kDefaultLineColor       [UIColor redColor]
#define kDefaultLineWidth       5.0f
#define kDefaultLineAlpha       1.0f
#define kSelectedLineColor      [UIColor blueColor]

static const double MarkClickSize = 5.0;    //标注的边缘点击响应区域大小
static const float MARK_CIRCLE_SIZE = 10;   //批注的四个边角圆形大小

typedef NS_ENUM(NSUInteger, TouchMode)
{
    MODE_REVIEW,         //批注模式
    MODE_PREVIEW         //预览模式
};

typedef NS_ENUM(NSUInteger, TouchType)
{
    NEW_MARK,           //按下去的动作是新建批注
    SELECT_MARK,        //按下去的动作是选中一个未被选中的批注
    UNSELECT_MARK,      //按下去的动作是选中一个已被选中的批注
    RESIZE_MARK         //按下去的动作是编辑已被选中的批注
};
// experimental code

@interface DrawingView ()
@property (nonatomic, strong)NSMutableArray *bufferArray;
@property (nonatomic, strong)DrawingTool *currentTool;

@property (nonatomic, strong)UIImage *image;
///按下去的点坐标
@property (nonatomic, assign)CGPoint touchDownPoint;

@property (nonatomic, assign)TouchType touchType;
@property (nonatomic, assign)NSInteger movedIndex;
@property (nonatomic, assign)TouchMode mode;
@end

#pragma mark -

@implementation DrawingView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMode) name:MsgChangeCorrectMode object:nil];
    }
    return self;
}
- (void)configure
{
    self.movedIndex = -1;
    self.mode = MODE_REVIEW;
    self.bufferArray = [NSMutableArray array];
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
}

/**
 切换模式
 */
- (void)changeMode {
    if (self.mode == MODE_PREVIEW) {
        self.mode = MODE_REVIEW;
    } else {
        self.mode = MODE_PREVIEW;
        [self cancelEdit];
    }
}
#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:self.bounds];
    if (self.movedIndex == -1) {
        [self.currentTool draw];
    }
    if (self.touchType == SELECT_MARK || self.touchType == RESIZE_MARK) {
        DrawingTool *rectT = self.bufferArray[self.movedIndex];
        [rectT drawCircle];
    }
}

- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
        self.image = nil;
        
        // I need to redraw all the lines
        for (DrawingTool *tool in self.bufferArray) {
            [tool draw];
        }
        if (self.touchType == SELECT_MARK || self.touchType == UNSELECT_MARK || self.touchType == RESIZE_MARK) {
            DrawingTool *rectT = self.bufferArray[self.movedIndex];
            [rectT drawCircle];
        }
        
    } else {
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // add the first touch
    UITouch *touch = [touches anyObject];
    self.touchDownPoint = [touch locationInView:self];
    if (self.mode == MODE_PREVIEW) {
        return;
    }
    //如果有选中的矩形, 先判断是否在矩形的小球上. 再判断是否在矩形边上.
    if (self.movedIndex != -1) {
        if ([self isInCircle]) {
            self.touchType = RESIZE_MARK;
            return;
        }
        if ([self isOnRectangleWithTool:self.bufferArray[self.movedIndex]]) {
            self.touchType = UNSELECT_MARK;
            return;
        } else {
            [self cancelEdit];
        }
    }
    //判断是否在其他线上
    for (int index = 0; index < self.bufferArray.count; index ++) {
        DrawingTool *rectTool = self.bufferArray[index];
        if ([self isOnRectangleWithTool:rectTool]) {
            self.movedIndex = index;
            rectTool.lineColor = kSelectedLineColor;
            [self.bufferArray replaceObjectAtIndex:index withObject:rectTool];
            [self setNeedsDisplay];
            [self updateCacheImage:YES];
            self.touchType = SELECT_MARK;
            if (self.showFunctionBtn) {
                self.showFunctionBtn();
            }
            return;
        }
    }
    self.currentTool = [DrawingTool new];
    self.currentTool.lineWidth = kDefaultLineWidth;
    self.currentTool.lineColor = kDefaultLineColor;
    self.currentTool.lineAlpha = kDefaultLineAlpha;
    self.currentTool.radius = MARK_CIRCLE_SIZE;
    [self.currentTool setInitialPoint:self.touchDownPoint];
    self.touchType = NEW_MARK;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.mode == MODE_PREVIEW) {
        return;
    }
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    // add the current point to the path
    CGPoint currentLocation = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    switch (self.touchType) {
        case SELECT_MARK:
        case UNSELECT_MARK: {
            DrawingTool *newRectTool = self.bufferArray[self.movedIndex];
            CGPoint newRectFirstPoint = CGPointMake(newRectTool.firstPoint.x + (currentLocation.x - previousLocation.x), newRectTool.firstPoint.y + (currentLocation.y - previousLocation.y));
            CGPoint newRectLastPoint = CGPointMake(newRectTool.lastPoint.x + (currentLocation.x - previousLocation.x), newRectTool.lastPoint.y + (currentLocation.y - previousLocation.y));
            [newRectTool moveFromPoint:newRectFirstPoint toPoint:newRectLastPoint];
            
            [self setNeedsDisplay];
            [self updateCacheImage:YES];
            break;
        }
        case NEW_MARK: {
            self.movedIndex = -1;
            [self.currentTool moveFromPoint:self.touchDownPoint toPoint:currentLocation];
            [self setNeedsDisplay];
            [self updateCacheImage:YES];
            break;
        }
        case RESIZE_MARK: {
            DrawingTool *newRectTool = self.bufferArray[self.movedIndex];
            CGPoint newRectLastPoint = CGPointMake(newRectTool.lastPoint.x + (currentLocation.x - previousLocation.x), newRectTool.lastPoint.y + (currentLocation.y - previousLocation.y));
            [newRectTool moveFromPoint:newRectTool.firstPoint toPoint:newRectLastPoint];
            [self setNeedsDisplay];
            [self updateCacheImage:YES];
            break;
        }
        default:
            break;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.mode == MODE_PREVIEW) {
        return;
    }
    //
    UITouch *touch = [touches anyObject];
    CGPoint endPoint  = [touch locationInView:self];
    if (self.touchType == NEW_MARK && !CGPointEqualToPoint(self.touchDownPoint, endPoint)) {
        [self.bufferArray addObject:self.currentTool];
        self.movedIndex = self.bufferArray.count - 1;
        
        
        self.currentTool.lineColor = kSelectedLineColor;
        [self.bufferArray replaceObjectAtIndex:self.movedIndex withObject:self.currentTool];
        [self setNeedsDisplay];
        [self updateCacheImage:YES];
        self.touchType = SELECT_MARK;
        if (self.showFunctionBtn) {
            self.showFunctionBtn();
        }
        
        // make sure a point is recorded
        [self touchesMoved:touches withEvent:event];
    }
    if (self.touchType == NEW_MARK && CGPointEqualToPoint(self.touchDownPoint, endPoint)) {
        self.movedIndex = -1;
    }
    // update the image
//    [self updateCacheImage:NO];
    
    // clear the current tool
    self.currentTool = nil;
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}
/**
 * 是否选中批注矩形框的四个圆角
 */
- (BOOL)isInCircle {
    //始终保持终点坐标lastPoint改变,firstPoint不变.
    DrawingTool *rectT = self.bufferArray[self.movedIndex];
    if ([self inCircleWithX:rectT.firstPoint.x y:rectT.firstPoint.y]) {
        CGPoint newRectFirstPoint = rectT.lastPoint;
        CGPoint newRectLastPoint = rectT.firstPoint;
        [rectT moveFromPoint:newRectFirstPoint toPoint:newRectLastPoint];
        return YES;
    }
    if ([self inCircleWithX:rectT.firstPoint.x y:rectT.lastPoint.y]) {
        CGPoint newRectFirstPoint = CGPointMake(rectT.lastPoint.x, rectT.firstPoint.y);
        CGPoint newRectLastPoint = CGPointMake(rectT.firstPoint.x, rectT.lastPoint.y);
        [rectT moveFromPoint:newRectFirstPoint toPoint:newRectLastPoint];
        return YES;
    }
    if ([self inCircleWithX:rectT.lastPoint.x y:rectT.firstPoint.y]) {
        CGPoint newRectFirstPoint = CGPointMake(rectT.firstPoint.x, rectT.lastPoint.y);
        CGPoint newRectLastPoint = CGPointMake(rectT.lastPoint.x, rectT.firstPoint.y);
        [rectT moveFromPoint:newRectFirstPoint toPoint:newRectLastPoint];
        return YES;
    }
    if ([self inCircleWithX:rectT.lastPoint.x y:rectT.lastPoint.y]) {
        return YES;
    }
    return  NO;
}
- (BOOL)inCircleWithX:(double)x y:(double)y {
    return pow(self.touchDownPoint.x - x, 2) + pow(self.touchDownPoint.y - y, 2) <= pow(MARK_CIRCLE_SIZE, 2);
}
#pragma mark 判断点击的点是否在屏幕中的矩形上
- (BOOL)isOnRectangleWithTool:(DrawingTool *) rectTool {
    //两条竖线
    BOOL isOnVertical = ((fabs(self.touchDownPoint.x - rectTool.firstPoint.x) <= MarkClickSize) || (fabs(self.touchDownPoint.x - rectTool.lastPoint.x) <= MarkClickSize)) && (((rectTool.firstPoint.y <= self.touchDownPoint.y) && (self.touchDownPoint.y <= rectTool.lastPoint.y)) || ((rectTool.firstPoint.y >= self.touchDownPoint.y) && (self.touchDownPoint.y >= rectTool.lastPoint.y)));
    //两条横线
    BOOL isOnHorizontal = ((fabs(self.touchDownPoint.y - rectTool.firstPoint.y) <= MarkClickSize) || (fabs(self.touchDownPoint.y - rectTool.lastPoint.y) <= MarkClickSize)) && (((rectTool.firstPoint.x <= self.touchDownPoint.x) && (self.touchDownPoint.x <= rectTool.lastPoint.x)) || ((rectTool.firstPoint.x >= self.touchDownPoint.x) && (self.touchDownPoint.x >= rectTool.lastPoint.x)));
    return isOnVertical || isOnHorizontal;
}

/**
 取消选中批注
 */
- (void)cancelEdit {
    if (self.movedIndex == -1) {
        return;
    }
    DrawingTool *rectT = self.bufferArray[self.movedIndex];
    rectT.lineColor = kDefaultLineColor;
    [self.bufferArray replaceObjectAtIndex:self.movedIndex withObject:rectT];
    self.touchType = NEW_MARK;
    [self setNeedsDisplay];
    [self updateCacheImage:YES];
    if (self.hiddenFunctionBtn) {
        self.hiddenFunctionBtn();
    }
}

/**
 删除单个批注
 */
- (void)deleteMark {
    [self.bufferArray removeObjectAtIndex:self.movedIndex];
    self.touchType = NEW_MARK;
    self.movedIndex = -1;
    [self setNeedsDisplay];
    [self updateCacheImage:YES];
    if (self.hiddenFunctionBtn) {
        self.hiddenFunctionBtn();
    }
}
#pragma mark dealWithData
/**
 获取该画布所有批注数据的json集合
 */
- (NSArray *)getMarkJsonArray {
    NSMutableArray *jsonArray = [NSMutableArray array];
    for (DrawingTool *tool in self.bufferArray) {
        [jsonArray addObject:[tool getJsonWithWidth:self.bounds.size.width height:self.bounds.size.height]];
    }
    return jsonArray;
}

/**
 根据json集合设置批注数据
 */
- (void)setMarkDataWithArray:(NSArray *) dataArray {
    for (NSDictionary *objData in dataArray) {
        DrawingTool *tool = [DrawingTool new];
        tool.lineWidth = kDefaultLineWidth;
        tool.lineColor = kDefaultLineColor;
        tool.lineAlpha = kDefaultLineAlpha;
        [tool MarkNodeWithData:objData width:self.bounds.size.width height:self.bounds.size.height];
    }
}
@end
