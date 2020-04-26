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
    private let animator: EGRotateAnimator
    var controlView:  EGPlayerControlView?

    @IBOutlet weak var displayView: DisplayerLayer!

    private var player: AVPlayer?
    
    var dismissBlock:(() -> Void)?
    
    
    init(view: DisplayerLayer, player: AVPlayer?, controlView: EGPlayerControlView) {
        self.player = player
        self.controlView = controlView
        animator = EGRotateAnimator(view: view)
        super.init(nibName: "FullScreenViewController", bundle: nil)
        self.controlView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.controlView ?? EGPlayerControlView())
        controlView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        controlView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        controlView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        controlView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        
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
            self.dismissBlock?()
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

extension UIView {
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
