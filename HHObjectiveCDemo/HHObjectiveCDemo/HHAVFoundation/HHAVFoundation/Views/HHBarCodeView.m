//
//  HHBarCodeView.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/12/21.
//

#import "HHBarCodeView.h"
#import <SCM-Swift.h>
@interface ScanAnimationView()
@property (nonatomic, strong)UIImageView * line_imageView;
@property (nonatomic, strong)NSTimer * animation_timer;
@property (nonatomic, assign)int addOrCut;
@end

@implementation ScanAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //使用CGContextRef重写drawRect方法会产生一个默认的黑色的北京，需要在初始化方法中提前设置为clearcolor
        [self setBackgroundColor:[UIColor clearColor]];
        
        // TODO: 待做
        //线移动的imageView
//        self.line_imageView=[[UIImageView alloc]initWithImage:[[UIColor blueColor] toImage]];
        self.line_imageView=[[UIImageView alloc]init];
        self.line_imageView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.line_imageView];
        
        //初始位置为当前视图距离顶部的四分之一处
        [self.line_imageView setFrame:CGRectMake(0, self.bounds.size.height/4, self.bounds.size.width, 20)];
    }
    return self;
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGFloat width = self.frame.size.width;        //视图宽度
    CGFloat height = self.frame.size.height;       //视图高度
    
    CGFloat lineWeight = 5;                      //线段宽度
    CGFloat lineLength = width / 10;                //线段长度
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context,0, 1, 0, 1.0);//画笔线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, lineWeight);
    
    CGPoint aPoints[2];//坐标点
    //左上 横
    aPoints[0] =CGPointMake(0, lineWeight/2);//坐标1
    aPoints[1] =CGPointMake(lineLength, lineWeight/2);//坐标2
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //左上 竖
    aPoints[0] =CGPointMake(lineWeight/2, 0);//坐标1
    aPoints[1] =CGPointMake(lineWeight/2 , lineLength);//坐标2
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //右上 横
    aPoints[0] =CGPointMake(width-lineLength,lineWeight/2);//坐标1
    aPoints[1] =CGPointMake(width, lineWeight/2);//坐标2
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //上，右，右
    
    aPoints[0] =CGPointMake(width-lineWeight/2, 0);//坐标1
    aPoints[1] =CGPointMake(width-lineWeight/2 , lineLength);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //下，左，左
    
    aPoints[0] =CGPointMake(lineWeight/2, height-lineLength);//坐标1
    aPoints[1] =CGPointMake(lineWeight/2 , height);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //下，左，底
    
    aPoints[0] =CGPointMake(0, height-lineWeight/2);//坐标1
    aPoints[1] =CGPointMake(lineLength , height-lineWeight/2);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //下，右，右
    
    aPoints[0] =CGPointMake(width-lineWeight/2, height-lineLength);//坐标1
    aPoints[1] =CGPointMake(width-lineWeight/2 , height);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //下，右，底
    
    aPoints[0] =CGPointMake(width-lineLength, height-lineWeight/2);//坐标1
    aPoints[1] =CGPointMake(width , height-lineWeight/2);//坐标2
    
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    aPoints[0] = CGPointMake(lineLength, 0);
    aPoints[1] = CGPointMake(width - lineLength, 0);
    CGContextAddLines(context, aPoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    aPoints[0] = CGPointMake(lineLength, height);
    aPoints[1] = CGPointMake(width - lineLength, height);
    CGContextAddLines(context, aPoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    aPoints[0] = CGPointMake(0, lineLength);
    aPoints[1] = CGPointMake(0, height - lineLength);
    CGContextAddLines(context, aPoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    aPoints[0] = CGPointMake(width, lineLength);
    aPoints[1] = CGPointMake(width, height - lineLength);
    CGContextAddLines(context, aPoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
}

/**
 开始动画
 */
- (void)startAnimation
{
    if (self.animation_timer) {
        [self.animation_timer invalidate];
    }
    WEAKSELF
    //创建一个定时器，这种创建方式需要手动将timer放到runloop中
    self.animation_timer=[NSTimer timerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (weakSelf.line_imageView.frame.origin.y>=self.frame.size.height*3/4) {
            weakSelf.addOrCut=-1;
        }
        else if (weakSelf.line_imageView.frame.origin.y<=self.frame.size.height/4)
        {
            weakSelf.addOrCut=1;
        }
        
        [weakSelf.line_imageView setFrame:CGRectMake(weakSelf.line_imageView.frame.origin.x, weakSelf.line_imageView.frame.origin.y+weakSelf.addOrCut, weakSelf.line_imageView.frame.size.width, weakSelf.line_imageView.frame.size.height)];
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:self.animation_timer forMode:NSDefaultRunLoopMode];
}
- (void)stopAnimation
{
    [self.animation_timer invalidate];
}
@end

@interface HHBarCodeView()

@end

@implementation HHBarCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat boxSize = 300, topHeight = 100;
        
        UIView *maskV = [[UIView alloc]initWithFrame:self.bounds];
        maskV.backgroundColor = [UIColor colorWithHex:0x0D0D0D alpha:0.6];
        [self addSubview:maskV];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        //镂空部分
        UIBezierPath *holePath = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.bounds.size.width - boxSize) * 0.5, topHeight, boxSize, boxSize) cornerRadius:1] bezierPathByReversingPath];
        [maskPath appendPath:holePath];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        maskV.layer.mask = maskLayer;
        
        self.scanAnimationV = [[ScanAnimationView alloc]initWithFrame:CGRectMake((self.bounds.size.width - boxSize) * 0.5, topHeight, boxSize, boxSize)];
        [self addSubview:self.scanAnimationV];
        [self.scanAnimationV startAnimation];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, topHeight + boxSize, self.bounds.size.width, 55)];
        [self addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"将二维码/条形码放入框中，即可扫描";
        
        UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 100, self.bounds.size.width, 100)];
        bottomV.backgroundColor = [UIColor redColor];
        [self addSubview:bottomV];
    }
    return self;
}

- (void)didDetect:(NSArray *)metadataObjects {
    [self.scanAnimationV stopAnimation];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
