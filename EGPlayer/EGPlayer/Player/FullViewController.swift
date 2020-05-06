//
//  FullViewController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class FullViewController: UIViewController {
    private let animator: EGRotateAnimator

    lazy var displayView = DisplayerLayer()

    private weak var controlView: UIView?

    private weak var player: AVPlayer?

    deinit {
        print("FullViewController_deinit")
    }

    init(controlView: UIView, player: AVPlayer, source: DisplayerLayer?) {
        self.controlView = controlView
        self.player = player
        animator = EGRotateAnimator(view: source)
        super.init(nibName: nil, bundle: nil)
//        transitioningDelegate = animator
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portraitUpsideDown
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        displayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displayView)
        displayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        displayView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        displayView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        displayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        guard let controlView = controlView else { return }
        controlView.translatesAutoresizingMaskIntoConstraints = false
        displayView.addSubview(controlView)
        controlView.topAnchor.constraint(equalTo: displayView.topAnchor).isActive = true
        controlView.leftAnchor.constraint(equalTo: displayView.leftAnchor).isActive = true
        controlView.rightAnchor.constraint(equalTo: displayView.rightAnchor).isActive = true
        controlView.bottomAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayView.setPlayer(player)
        print("全屏将要显示")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayView.setPlayer(nil)
        controlView?.removeFromSuperview()
        print("全屏将要消失")
    }
}
