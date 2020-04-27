//
//  EGPlayerViewController.swift
//  EGPlayer
//
//  Created by Jason on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class EGPlayerViewController: UIViewController {
        
    lazy var controlView = EGPlayerControlView()
    
    lazy var player = EGPlayer(displayView: displayView, controlView: controlView)
    
    deinit {
        print("PlayerViewController_deinit")
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeRight, .portrait]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
                
        controlView.backBtnClickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        gestureControl.addGestureToView(view: controlView.portraitControlView.middleView)
        controlView.showBtnClickCallBack = { [weak self] in
            self?.presentFullView()
        }
    }
    
    ///播放
    func playerUrl(_ url: String) {
        player.setUrl(url)
    }
    
    func presentFullView() {
        displayView.tempFrame = view.convert(displayView.frame, to: view)
        displayView.setPlayer(nil)
        controlView.isFullScreen = true
        let vc = FullScreenViewController(view: displayView, player: player.player, controlView: self.controlView)
        vc.dismissBlock = { [weak self] in
            self?.controlView.isFullScreen = false
        }
        present(vc, animated: true, completion: nil)
    }
    
    private lazy var gestureControl: EGPlayerGestureControl = {
        let gestureControl = EGPlayerGestureControl()
        gestureControl.singleTapped = {   [weak self] _ in
            self?.controlView.gestureSingleTapped()
        }
        return gestureControl
    }()
    
    lazy var displayView: DisplayerLayer = {
        let displayer = DisplayerLayer()
        displayer.frame = self.view.bounds
        return displayer
    }()
}
