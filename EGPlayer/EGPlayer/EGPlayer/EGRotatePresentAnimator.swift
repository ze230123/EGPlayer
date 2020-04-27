//
//  EGRotatePresentAnimator.swift
//  EGPlayer
//
//  Created by Jason on 2020/4/26.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit


class EGRotateAnimator: NSObject {
    let view: DisplayerLayer?
    init(view: DisplayerLayer?) {
        self.view = view
        super.init()
    }
}

extension EGRotateAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return EGRotatePresentAnimator(view: view)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return EGRotateDismissAnimator(view: view)
    }
}

class EGRotatePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let view: DisplayerLayer?
    init(view: DisplayerLayer?) {
        self.view = view
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
            let presentedViewController = transitionContext.viewController(forKey: .to),
            let view = view  else {
            return
        }

        let containerView = transitionContext.containerView
        toView.frame = containerView.bounds
        
        let center = containerView.convert(view.center, from: view)
        toView.frame = view.bounds
        toView.center = center
        toView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        containerView.addSubview(toView)
        
        let presentedViewFinalFrame = transitionContext.finalFrame(for: presentedViewController)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.transform = .identity
            toView.frame = presentedViewFinalFrame
            view.frame = toView.bounds
        }) { (_) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}

class EGRotateDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let view: DisplayerLayer?
    init(view: DisplayerLayer?) {
        self.view = view
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let view = view else {
            return
        }
        
        // 计算 fromView的最终位置
        let smallMovieFrame = transitionContext.containerView.convert(view.tempFrame, from: view.parentView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .layoutSubviews, animations: {
            fromView.transform = .identity
            fromView.frame = smallMovieFrame
        }) { (_) in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
