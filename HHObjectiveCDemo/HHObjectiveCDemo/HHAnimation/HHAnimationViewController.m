//
//  HHAnimationViewController.m
//  HHAnimationDemo
//
//  Created by FN-116 on 2021/12/7.
//

#import "HHAnimationViewController.h"

@interface HHAnimationViewController ()
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIButton *banner;
@property (nonatomic, strong) UIImageView *cloud;
@property (nonatomic, strong) UIImageView *balloon;
@end

@implementation HHAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark block-based animation
- (void)handleBlockPropertyAnimation {
    //开始动画时间
    NSTimeInterval beginAnimation = 0;
    //设置动画执行的时间
    NSTimeInterval animationDuration = 1.0;
    //    //设置动画重复的次数
    //    CGFloat animationRepeatCount = 10;
    
    //    //设置动画变化的曲线
    //    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    /**
     UIViewAnimationOptionAutoreverse 可以反转（倒回来）
     */
    [UIView animateWithDuration:animationDuration delay:beginAnimation options:UIViewAnimationOptionAutoreverse animations:^{
        //修改视图的属性
        self.redView.center = CGPointMake(self.redView.center.x, self.redView.center.y + 200);
        self.redView.alpha = 0.0;
    } completion:^(BOOL finished) {
        //设置动画结束之后需要执行的操作
        self.redView.alpha = 1.0;
        self.redView.center = CGPointMake(self.redView.center.x, self.redView.center.y - 200);
    }];
    
    
    //Block4: 弹簧效果
    /**
     duration：代表动画执行的时间。
     delay：代表动画延迟执行的时间。
     dampingRatio：代表代表弹簧抖动的频率（0 - 1），值越小频率越高。
     velocity：代表弹簧开始抖动的速度。
     options：代表动画的效果。
     animations：具体执行的动画。
     completion：动画结束之后执行的操作。
     */
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:30 options:UIViewAnimationOptionCurveLinear animations:^{
        self.banner.center = CGPointMake(self.banner.center.x, self.banner.center.y + 50);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark UIView Transition Animation
- (void)handleTransitionAnimation {
    //UIView的过渡动画分为单一视图的过渡动画，和视图之间的过渡动画
    //    //单一视图的过渡动画
    //    [UIView transitionWithView:self.redView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
    //        self.redView.transform = CGAffineTransformScale(self.redView.transform, 0.5, 0.5);
    //    } completion:^(BOOL finished) {
    //        self.redView.transform = CGAffineTransformScale(self.redView.transform, 10 / 5.0, 10 / 5.0);
    //    }];
    //两个视图之间的过渡动画
    UIView *yellowView = [[UIView alloc]initWithFrame:self.redView.frame];
    yellowView.backgroundColor = [UIColor yellowColor];
    [UIView transitionFromView:self.redView toView:yellowView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromTop completion:^(BOOL finished) {
        
    }];
}
- (void)handleLayer {
    //CALayer动画本质上是CALayer做的动画，CALayer用来帮视图绘制需要展示的内容，UIView或其子类负责将绘制的内容进行展示。CALayer和UIView两者之间是相辅相成，缺少任何一方 另外一方也没有存在的必要。
    //1：修改UIView边框的宽度
    self.redView.layer.borderWidth = 6;
    //2:修改视图边框的颜色
    self.redView.layer.borderColor = [UIColor blueColor].CGColor
    ;
    //3：修改视图边角
    self.redView.layer.cornerRadius = 10;
    //4:获得锚点的坐标
    CGPoint anchP = self.redView.layer.anchorPoint;
    NSLog(@"%@",NSStringFromCGPoint(anchP));
    //5:获得红色视图基准点坐标
    CGPoint position = self.redView.layer.position;
    NSLog(@"%@",NSStringFromCGPoint(position));
    //修改锚点的坐标
    //    self.redView.layer.anchorPoint = CGPointMake(0, 0.5);
    //修改基准点坐标
    self.redView.layer.position = CGPointMake(187.5, 250);
    //视图锚点只能在视图内部，坐标范围[0 1]，视图在执行某个操作的时候必须保证锚点和基准点重合。因此当修改锚点或基准点的坐标会引起视图位置的变化，并且锚点会主动向基准点靠齐。
    NSLog(@"%@",NSStringFromCGPoint(self.redView.center));
}
#pragma mark CALayer-BasicAnimation
- (void)handleBasicAnimation {
    //CALayer层动画修改的属性值最终不会作用到对应的控件上
    //1:设置需要修改的layer层属性
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    //2:设置对应控件Layer层position的x坐标的起始值
    basicAnimation.fromValue = @(-50);
    //设置最终值
    basicAnimation.toValue = @(425);
    //3:设置动画的时间
    basicAnimation.duration = 3;
    //4:设置动画重复的次数
    basicAnimation.repeatCount = 2;
    //5:将动画添加到对应的控件Layer层上
    [self.cloud.layer addAnimation:basicAnimation forKey:nil];
}
#pragma mark CALayer-KeyframeAnimation
- (void)handleKeyFromAnimation {
    //1:指定动画需要修改的属性
    CAKeyframeAnimation *keyFramA = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //2:设置每针动画的起始和结束点
    CGPoint point1 = self.cloud.center;
    CGPoint point2 = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, -25);
    CGPoint point3 = CGPointMake([UIScreen mainScreen].bounds.size.width + 50, point1.y);
    NSValue *pointV1 = [NSValue valueWithCGPoint:point1];
    NSValue *pointV2 = [NSValue valueWithCGPoint:point2];
    NSValue *pointV3 = [NSValue valueWithCGPoint:point3];
    keyFramA.values = @[pointV1,pointV2,pointV3,pointV1];
    //3：设置动画的时间（指的是完成整个动画所用的时间）
    keyFramA.duration = 3;
    //4：设置动画重复的次数
    keyFramA.repeatCount = 10000;
    //5:将动画添加到指定控件的Layer层上
    [self.cloud.layer addAnimation:keyFramA forKey:nil];
}
#pragma mark Animation Group
//处理分组动画
- (void)handleGroupAnimation {
    //1：使用关键帧动画创建按照圆形轨迹移动的动画
    CAKeyframeAnimation *keyFrom1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //2:获取圆形轨迹的半径
    CGFloat redius = [UIScreen mainScreen].bounds.size.height / 2;
    //3:使用贝塞尔曲线获取圆形轨迹
    UIBezierPath *bezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, redius) radius:redius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    //4:指定气球的轨迹为该半圆形轨迹
    keyFrom1.path = bezier.CGPath;
    //5：设置动画时间
    keyFrom1.duration = 5;
    //创建一个关键帧动画执行气球放大和缩小操作
    //1:指定需要修改的属性
    CAKeyframeAnimation *scaleFrom = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    //2:设置每一帧动画放大的比例
    scaleFrom.values = @[@1.0,@1.2,@1.4,@1.6,@1.8,@2.0,@1.8,@1.6,@1.4,@1.2,@1.0];
    //3:设置动画的时间
    scaleFrom.duration = 5;
    
    //组合动画：将多个动画加入到一个分组中，同时执行。
    //1:创建组合动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    //2:向分组中添加动画
    group.animations = @[keyFrom1, scaleFrom];
    //3:设置动画的时间
    group.duration = 5;
    //4:设置分组动画重复次数
    group.repeatCount = 10000;
    //VIP:添加分组动画到指定的UI控件上
    [self.balloon.layer addAnimation:group forKey:nil];
}
#pragma mark Transition Animation 过渡动画
- (void)handleLayerTransitionAnimation {
    //1:创建过渡动画
    CATransition *transition = [CATransition animation];
    //2:设置过渡动画的类型
    //在开发过程中只有"moveIn","push","reveal","fade"可以使用
    transition.type = @"push";//rotate,cameraIrisHollowOpen,cameraIrisHollowClose
    //3:指定过渡动画的过渡方向（kCATransitionFromLeft，kCATransitionFromRight,kCATransitionFromBottom,kCATransitionFromTop）
    transition.subtype = kCATransitionFromLeft; //从左边开始过渡
    [self.redView.layer addAnimation:transition forKey:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
