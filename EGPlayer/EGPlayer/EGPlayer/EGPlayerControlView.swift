//
//  EGPlayerControlView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class EGPlayerControlView: UIView, PlayerControlable {
    
     var player: AVPlayer? {
        didSet {
            self.portraitControlView.player = self.player
            self.landScapeControlView.player = self.player
        }
    }
    
    var backBtnClickCallback: (() -> Void)?
    /// 控制层显示或者隐藏
    var controlViewAppeared: Bool = false
    
    
    ///监听是否横屏竖屏
    var isFullScreen: Bool = false
//    {
//        return false
//    }
    
    var totalTime: Double {
        return self.player?.currentItem?.duration.seconds ?? 0
    }
    
    var currentTime: Double {
        return self.player?.currentItem?.currentTime().seconds ?? 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
        
    }
    
    func initSubViews() {
        self.backgroundColor = .clear
        
        self.portraitControlView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(portraitControlView)
        portraitControlView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        portraitControlView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        portraitControlView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        portraitControlView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        self.landScapeControlView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(landScapeControlView)
        landScapeControlView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        landScapeControlView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        landScapeControlView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        landScapeControlView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addSubview(self.loadingView)
    }
    
    // MARK: - lazy Load
    
    ///竖屏view
    lazy var portraitControlView: EGPortraitControlView = {
        let portraitControlView = EGPortraitControlView()
        portraitControlView.isHidden = false
        portraitControlView.backButtonActionBlock = {[weak self] in
            self?.backBtnClickCallback?()
        }
        portraitControlView.showButtonActionBlock = {[weak self] in
            self?.setControlViewOrientation(true)
        }
        return portraitControlView
    }()
    
    ///横屏view
    lazy var landScapeControlView: EGLandScapeControlView = {
        let landScapeControlView = EGLandScapeControlView()
        landScapeControlView.isHidden = true
        landScapeControlView.backButtonActionBlock = {[weak self] in
            
        }
        landScapeControlView.showButtonActionBlock = {[weak self] in
            
        }
        
        return landScapeControlView
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.center = self.center
        loadingView.isHidden = true
        loadingView.style = .gray
        return loadingView
    }()
}

/// controlView 方法
extension EGPlayerControlView {
    
    func setControlViewOrientation(_ fullScreen: Bool) {
        
        self.isFullScreen = fullScreen
        self.portraitControlView.isHidden = fullScreen
        self.landScapeControlView.isHidden = !fullScreen
        if self.controlViewAppeared {
            self.showAllControlViewWithAnimated(false)
        } else {
            self.hideAllControlViewWithAnimated(false)
        }
    }
    
    ///隐藏控制层
    func hideAllControlViewWithAnimated(_ animated: Bool) {
        controlViewAppeared = false
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            if self.isFullScreen {
                self.landScapeControlView.hideControlView()
            } else {
                self.portraitControlView.hideControlView()
            }
        }) { (finished) in
            print(finished)
        }
    }
    
    func showAllControlViewWithAnimated(_ animated: Bool) {
        controlViewAppeared = true
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            if self.isFullScreen {
                self.landScapeControlView.showControlView()
            } else {
                self.portraitControlView.showControlView()
            }
            
        }) { (finished) in
            print(finished)
        }
    }
    
    func startAnimating() {
        self.loadingView.startAnimating()
        self.loadingView.isHidden = false
    }
    
    func stopAnimating() {
        self.loadingView.stopAnimating()
        self.loadingView.isHidden = true
    }
    
}

///PlayerControlable 协议方法
extension EGPlayerControlView {
    
    /// 播放失败
    func playFaild(error: Error) {
        stopAnimating()
    }
    
    /// 视频需要缓冲
    func playDidCache() {
        startAnimating()
        
    }
    
    /// 视频可以播放
    func playDidCanPlay() {
        stopAnimating()
    }
    
    func playerDidChangedState(_ state: EGPlayer.State) {
        
        switch state {
        case.loading:
            startAnimating()
        case .playing:
            self.portraitControlView.playBtnSelectedState(true)
            self.landScapeControlView.playBtnSelectedState(true)
            stopAnimating()
        case .paused, .playEnd:
            self.portraitControlView.playBtnSelectedState(false)
            self.landScapeControlView.playBtnSelectedState(false)
        case .cacheing:
            startAnimating()
        case .failed(let error):
            print(error)
            self.portraitControlView.playBtnSelectedState(false)
            self.landScapeControlView.playBtnSelectedState(false)
            stopAnimating()
            
        case .readyToPlay:
            print("readyToPlay")
        }
        
    }
    
    func setCacheProgress(_ progress: Double) {
        self.portraitControlView.sliderView.bufferValue = CGFloat(progress)
        self.landScapeControlView.sliderView.bufferValue = CGFloat(progress)
        
    }
    
    func setPlayTime(_ time: Double, total: Double) {
        self.portraitControlView.currentTime = time
        self.portraitControlView.totalTime = total
        self.portraitControlView.sliderView.value = CGFloat(time / total)
        
        self.landScapeControlView.currentTime = time
        self.landScapeControlView.totalTime = total
        self.landScapeControlView.sliderView.value = CGFloat(time / total)
    }
}
