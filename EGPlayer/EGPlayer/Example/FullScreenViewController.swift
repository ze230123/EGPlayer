//
//  FullScreenViewController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/24.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class FullScreenViewController: UIViewController {
    private let animator: EGRotateAnimator
    var controlView:  EGPlayerControlView?
    @IBOutlet weak var displayView: DisplayerLayer!
    
    var brightness = UIScreen.main.brightness
    var volume: Float = 0 {
//        get {
//            var volume = self.volumeViewSlider.value
//            if (volume == 0) {
//                volume = AVAudioSession.sharedInstance().outputVolume
//            }
//            return volume
//        }
        
        didSet {
//            let volume = MIN(MAX(0, volume), 1)
            self.volumeViewSlider.value = self.volume
        }
        
    }

    private var player: AVPlayer?
    
    var dismissBlock:(() -> Void)?
    
    
    init(view: DisplayerLayer, player: AVPlayer?, controlView: EGPlayerControlView) {
        self.player = player
        self.controlView = controlView
        animator = EGRotateAnimator(view: view)
        super.init(nibName: "FullScreenViewController", bundle: nil)
        transitioningDelegate = animator
        modalPresentationStyle = .fullScreen
        initSubViews()
    }
    
    func initSubViews() {
        
        self.controlView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.controlView ?? EGPlayerControlView())
        controlView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        controlView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        controlView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        controlView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        gestureControl.addGestureToView(view: animator.view)
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
    
    private lazy var gestureControl: EGPlayerGestureControl = {
        let gestureControl = EGPlayerGestureControl()
        return gestureControl
    }()
    
    lazy var volumeView:MPVolumeView = {
        let volumeView:MPVolumeView = MPVolumeView.init()
        for view in volumeView.subviews {
            if (NSStringFromClass(view.classForCoder) == "MPVolumeSlider"){
                self.volumeViewSlider = (view as! UISlider)
                break
            }
        }
        volumeView.frame = .zero
        return volumeView
    }()
    
    lazy var volumeViewSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
}

extension FullScreenViewController {
    /*
    /// 滑动中手势事件
    - (void)gestureChangedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location withVelocity:(CGPoint)velocity {
        if (direction == ZFPanDirectionH) {
        
            [self sliderValueChangingValue:self.sumTime/totalMovieDuration isForward:style];
        } else if (direction == ZFPanDirectionV) {
            if (location == ZFPanLocationLeft) { /// 调节亮度
                self.player.brightness -= (velocity.y) / 10000;
                [self.volumeBrightnessView updateProgress:self.player.brightness withVolumeBrightnessType:ZFVolumeBrightnessTypeumeBrightness];
            } else if (location == ZFPanLocationRight) { /// 调节声音
                self.player.volume -= (velocity.y) / 10000;
                if (self.player.isFullScreen) {
                    [self.volumeBrightnessView updateProgress:self.player.volume withVolumeBrightnessType:ZFVolumeBrightnessTypeVolume];
    }*/
    func gestureChangedPan(_ control: EGPlayerGestureControl, _ derection: EGPlayerGestureControl.PanDirection, _ location: EGPlayerGestureControl.PanLoacation, _ velocity: CGPoint)  {
          if derection == .V {
              if location == .left {
                self.brightness -= velocity.y / 10000
              } else {
                self
            }
          }
      }
    
}
