//
//  FullScreenViewController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/24.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class FullScreenViewController: UIViewController {
    private let animator: RotateAnimator
    @IBOutlet weak var displayView: DisplayerLayer!

    private var player: AVPlayer?
    
    init(view: DisplayerLayer, player: AVPlayer?) {
        self.player = player
        animator = RotateAnimator(view: view)
        super.init(nibName: "FullScreenViewController", bundle: nil)
        transitioningDelegate = animator
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displayView.setPlayer(player)
    }

    @IBAction func dismissAction() {
        dismiss(animated: true, completion: nil)
        dismiss(animated: true) {
            self.animator.view.setPlayer(self.player)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
}

class RotateAnimator: NSObject {
    let view: DisplayerLayer
    init(view: DisplayerLayer) {
        self.view = view
        super.init()
    }
}

extension RotateAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RotatePresentAnimator(view: view)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RotateDismissAnimator(view: view)
    }
}

class RotatePresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let view: DisplayerLayer
    init(view: DisplayerLayer) {
        self.view = view
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to), let presentedViewController = transitionContext.viewController(forKey: .to)  else {
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
            self.view.frame = toView.bounds
        }) { (_) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}

class RotateDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let view: DisplayerLayer
    init(view: DisplayerLayer) {
        self.view = view
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from), let fromVC = transitionContext.viewController(forKey: .from) else {
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

extension UIView {
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
