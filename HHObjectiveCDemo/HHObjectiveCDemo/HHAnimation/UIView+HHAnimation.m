//
//  UIView+HHAnimation.m
//  HHAnimationDemo
//
//  Created by FN-116 on 2021/12/7.
//

#import "UIView+HHAnimation.h"

@implementation UIView (HHAnimation)

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(TZOscillatoryAnimationType)type{
    NSNumber *animationScale1 = type == TZOscillatoryAnimationToBigger ? @(1.15) : @(0.5);
    NSNumber *animationScale2 = type == TZOscillatoryAnimationToBigger ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

#pragma mark - 缩放一
- (void)keyFrameAnimation {
    //1:指定需要修改的属性
    CAKeyframeAnimation *scaleFrom = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    //2:设置每一帧动画放大的比例
    scaleFrom.values = @[@0.0,@0.2,@0.4,@0.6,@0.8,@1.0];
    //3:设置动画的时间
    scaleFrom.duration = 0.33;
    [self.layer addAnimation:scaleFrom forKey:nil];
}

#pragma mark - 缩放二
/**
 CGAffineTransformMakeScale是对单位矩阵进行缩放。

 CGAffineTransformScale是对第一个参数的矩阵进行缩放。

 比如已经对一个view缩放0.5，还想在这个基础上继续缩放0.5，那么就把这个view.transform作为第一个参数传到CGAffineTransformScale里面，缩放之后的view则变为0.25(CGAffineTransformScale(view.transofrm,0.5,0.5))。
 如果用CGAffineTransformMakeScale方法，那么这个view仍旧是缩放0.5(CGAffineTransformMakeScale(0.5,0.5))。
 */
- (void)transformScale {
    CGAffineTransform transform =
    CGAffineTransformScale(self.transform, 0.1, 0.1);
    [self setTransform:transform];
}

#pragma mark - 平移
- (void)transformMakeTranslation {
    CGAffineTransform transform = CGAffineTransformMakeTranslation(1, 1);
    [self setTransform:transform];
}

#pragma mark - 清空所有的设置的transform，恢复成原来的状态。
- (void)reset_transform {
    self.transform = CGAffineTransformIdentity;
}


#pragma mark - 透明度
- (void)alphaAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.alpha = 0.0;
    } completion:nil];
}

#pragma mark - 先上移放大组动画 上移放大组动画结束之后 震荡动画
// 添加上移放大组动画
- (void)scaleForeverAnimation {
    //上移动效
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnimation.fromValue = @(self.center.y);
    positionAnimation.toValue = @(self.center.y - 18);
    
    //放大动效
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(1.0);
    scaleAnimation.toValue = @(1.35);
//    scaleAnimation.autoreverses = YES;
//    scaleAnimation.duration = time;
//    scaleAnimation.repeatCount = 1;
//    scaleAnimation.removedOnCompletion = NO;
//    scaleAnimation.fillMode = kCAFillModeForwards;
//    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:scaleAnimation,positionAnimation ,nil];
    group.duration = 1.0f;
    group.delegate = self;
    //取消动画反弹 取消恢复状态
    group.removedOnCompletion = NO;
    //设置动画执行完成后保持最新的效果
    group.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:group forKey:nil];
}

#pragma mark - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CGPoint startPoint = CGPointMake(self.center.x, self.center.y - 18);
    [self springAnimationWithStart:startPoint];
}

#pragma mark - 震动动画
- (void)springAnimationWithStart:(CGPoint )startPoint {
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position"];
    springAnimation.mass = 1;//质量，影响图层运动时的弹簧惯性,质量越大，弹簧拉伸和压缩的幅度越大,默认1
    springAnimation.stiffness = 2800.0f;//弹性系数，弹性系数越大，形变产生的力就越大，运动越快，默认100
    springAnimation.damping = 30;//阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快，默认10
    springAnimation.initialVelocity = 80.0f;//动画视图的初始速度大小，默认0
    springAnimation.duration = springAnimation.settlingDuration;//结算时间 返回弹簧动画到停止时的估算时间
    springAnimation.fillMode = kCAFillModeForwards;//动画结束后保持最新状态
    springAnimation.autoreverses = NO;//不做逆动画
    springAnimation.removedOnCompletion = NO;//动画结束后移除
    springAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(startPoint.x, startPoint.y - 18)];
    [self.layer addAnimation:springAnimation forKey:@"spring"];
}

@end
