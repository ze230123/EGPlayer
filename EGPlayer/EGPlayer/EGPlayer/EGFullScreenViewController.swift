//
//  EGFullScreenViewController.swift
//  EGPlayer
//
//  Created by Jason on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class EGFullScreenViewController: UIViewController {
    
    private let animator: EGRotateAnimator
    var controlView:  EGPlayerControlView
    
    var brightness = UIScreen.main.brightness
    var volume = AVAudioSession.sharedInstance().outputVolume
    var volumeViewSlider: UISlider?
    
    private var player: AVPlayer?
    
    var dismissBlock:(() -> Void)?
    
    
    init(view: DisplayerLayer, player: AVPlayer?, controlView: EGPlayerControlView) {
        self.player = player
        self.controlView = controlView
        animator = EGRotateAnimator(view: view)
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = animator
        modalPresentationStyle = .fullScreen
        initSubViews()
    }
    
    func initSubViews() {
        
        self.displayView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.displayView)
        displayView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        displayView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        displayView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        displayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.controlView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.controlView)
        controlView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        controlView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        controlView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        controlView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gestureControl.addGestureToView(view: controlView.landScapeControlView.middleView)
        initVolumeView()
        
        controlView.backBtnClickCallback = {
            self.dimissView()
        }
        
        
    }
    
    func initVolumeView() {
        
        let volumeView = MPVolumeView()
        MPVolumeSettingsAlertHide()
        for view in volumeView.subviews {
            if (NSStringFromClass(view.classForCoder) == "MPVolumeSlider"){
                self.volumeViewSlider = (view as! UISlider)
                break
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayView.setPlayer(player)
    }
    
    @IBAction func dismissAction() {
        dimissView()
    }
    
    func dimissView() {
        dismiss(animated: true, completion: nil)
        dismiss(animated: true) {
//            self.animator.view.setPlayer(self.player)
//            self.dismissBlock?()
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
    
    lazy var displayView: DisplayerLayer = {
        let displayer = DisplayerLayer()
        return displayer
    }()
    
    private lazy var gestureControl: EGPlayerGestureControl = {
        let gestureControl = EGPlayerGestureControl()
        gestureControl.singleTapped = {   [weak self] _ in
            self?.controlView.gestureSingleTapped()
        }
        
        gestureControl.changedPan = { [weak self] (control, derection, location, velocity) in
            self?.gestureChangedPan(control, derection, location, velocity)
        }
        
        return gestureControl
    }()
    
}

extension EGFullScreenViewController {
    
    func getVolume() -> Float {
        var volume = self.volumeViewSlider?.value
        if (volume == 0) {
            volume = AVAudioSession.sharedInstance().outputVolume
        }
        return volume ?? 0
    }
    
    func gestureChangedPan(_ control: EGPlayerGestureControl, _ derection: EGPlayerGestureControl.PanDirection, _ location: EGPlayerGestureControl.PanLoacation, _ velocity: CGPoint)  {
        if derection == .V {
            if location == .left {
                self.brightness -= velocity.y / 10000
                UIScreen.main.brightness = self.brightness
            } else if location == .right {
                var volume = getVolume()
                volume -= Float(velocity.y / 10000)
                self.volumeViewSlider?.value = volume
            }
        }
    }
    
}

