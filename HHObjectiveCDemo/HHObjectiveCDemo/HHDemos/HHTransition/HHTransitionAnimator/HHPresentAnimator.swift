//
//  HHPresentAnimator.swift
//  HHSwift
//
//  Created by Michael on 2023/2/3.
//  转场动画

import Foundation
import UIKit

class HHPresentAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.45
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // MARK: 动画
        let containerView: UIView = transitionContext.containerView
        let fromViewController: UIViewController = transitionContext.viewController(forKey: .from)!
        let toViewController: UIViewController = transitionContext.viewController(forKey: .to)!
        let fromView: UIView = fromViewController.view
        let toView: UIView = toViewController.view
        let viewWidth: CGFloat = SCREEN_WIDTH * 3.0 / 4
        let viewHeight: CGFloat = SCREEN_HEIGHT * 3.0 / 4
        // 这里present不和push一样需要自己标记，这里直接有跟踪标记
        if toViewController.isBeingPresented {
            containerView.addSubview(toView)
            toView.frame = CGRect(x: SCREEN_WIDTH, y: (SCREEN_HEIGHT - viewHeight) / 2.0, width: viewWidth, height: viewHeight)
            //加了一个蒙层
            let maskView: UIView = UIView()
            maskView.backgroundColor = .black.withAlphaComponent(0.3)
            maskView.center = containerView.center
            maskView.bounds = containerView.bounds
            containerView.insertSubview(maskView, belowSubview: toView)
            //设置动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                toView.frame = CGRect(x: (SCREEN_WIDTH - viewWidth) / 2.0, y: (SCREEN_HEIGHT - viewHeight) / 2.0, width: viewWidth, height: viewHeight)
            } completion: { Bool in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            //返回
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                fromView.frame = CGRect(x: (SCREEN_WIDTH - viewWidth) / 2.0, y: SCREEN_HEIGHT, width: viewWidth, height: viewHeight)
            } completion: { Bool in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
