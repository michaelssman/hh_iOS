//
//  HHTransitionAnimator.m
//  YYT_art
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HHTransitionAnimator.h"
@interface HHTransitionAnimator ()
@end

@implementation HHTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self pushAnimateTransition:transitionContext];
}
#pragma mark ————— push —————
- (void)pushAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //获取跳转的Controller和目标Controller
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //from和to的两个视图
    __block UIView * fromView = fromVC.view;
    __block UIView * toView = toVC.view;
    
    //container容器加入要显示的视图 不加入fromVC 返回的时候就无法返回
    UIView * containerView = [transitionContext containerView];
//    [containerView addSubview:fromView];
    [containerView addSubview:toView];
//    toView.backgroundColor = [UIColor clearColor];
    toView.frame = CGRectMake(100, 0, 200, 600);
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];

}

@end
