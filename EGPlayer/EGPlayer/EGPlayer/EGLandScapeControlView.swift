//
//  EGLandScapeControlView.swift
//  EGPlayer
//
//  Created by Jason on 2020/4/24.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class EGLandScapeControlView: UIView, NibLoadable {
    
    /// 顶部工具栏
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    /// 底部工具栏
    @IBOutlet weak var bottomView: UIView!
    /// 播放或暂停按钮
    @IBOutlet weak var playerButton: UIButton!
    
    /// 播放的当前时间
    @IBOutlet weak var currentTimeLabel: UILabel!
    /// 全屏按钮
    @IBOutlet weak var showButton: UIButton!
    /// 视频总时间
    @IBOutlet weak var allTimeLabel: UILabel!
    /// 滑杆
    @IBOutlet weak var sliderView: EGSliderView!
    
    var player: AVPlayer?
    var backButtonActionBlock: (() -> Void)?
    var showButtonActionBlock: (() -> Void)?

    
    var totalTime: Double = 0 {
//        return self.player?.currentItem?.duration.seconds ?? 0
        didSet {
            self.allTimeLabel.text = convertTimeSecond(timeSecond: Int(totalTime))
        }
    }
    
    var currentTime: Double = 0  {
        didSet {
            self.currentTimeLabel.text = convertTimeSecond(timeSecond: Int(currentTime))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
        initSubViews()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
        initSubViews()
        
    }
    
    func initSubViews() {
        
        self.sliderView.value = 0
        self.sliderView.bufferValue = 0
        self.sliderView.delegate = self
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backButtonActionBlock?()
    }
    
    @IBAction func showButtonAction(_ sender: Any) {
        self.showButtonActionBlock?()
    }
    
    @IBAction func playPauseButtonClickAction(_ sender: Any) {
        playOrPause()
    }
}

extension EGLandScapeControlView {

    
    func showControlView() {
        topView.alpha = 1
        bottomView.alpha = 1
    }
    
    func hideControlView() {
        topView.alpha = 0
        bottomView.alpha = 0
    }
    
    func playOrPause() {
        self.playerButton.isSelected = !self.playerButton.isSelected
        self.playerButton.isSelected ? self.player?.play() : self.player?.pause()
    }
    
    func playBtnSelectedState(_ seleted: Bool) {
        self.playerButton.isSelected = seleted
    }
    
    func convertTimeSecond(timeSecond: Int) -> String {
        var lastTime = ""
        if timeSecond < 60 {
            lastTime = NSString(format: "00:%02zd", timeSecond) as String
        } else if timeSecond >= 60 && timeSecond < 3600 {
            lastTime = NSString(format: "%02zd:%02zd", timeSecond / 60, timeSecond % 60) as String
        } else {
            lastTime = NSString(format: "%02zd:%02zd:%02zd", timeSecond / 3600, timeSecond % 3600 / 60, timeSecond % 60) as String
        }
        return lastTime
    }
}


extension EGLandScapeControlView: EGSliderViewDelegate {
    
    func sliderTouchBegan(value: TimeInterval) {
        self.sliderView.isdragging = true
    }
    
    func sliderTouchEnded(value: TimeInterval) {
        if totalTime > 0 {
            self.player?.seek(to: CMTimeMakeWithSeconds(value * totalTime, preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { [weak self] (finished) in
                if finished {
                    self?.sliderView.isdragging = false
                }
            })
        } else {
            self.sliderView.isdragging = false
        }
        
    }
    
    
    func sliderValueChanged(value: TimeInterval) {
        
        if totalTime == 0 {
            self.sliderView.value = 0
            return
        }
        guard totalTime != 0 else {
            self.sliderView.value = 0
            return
        }
        self.sliderView.isdragging = true
        let currentTimeString = convertTimeSecond(timeSecond: Int(totalTime * value))
        self.currentTimeLabel.text = currentTimeString
    }
    
    
    
    func sliderTapped(value: TimeInterval) {
        if totalTime > 0 {
            self.sliderView.isdragging = true
            self.player?.seek(to: CMTimeMakeWithSeconds(value * totalTime, preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { [weak self] (finished) in
                if finished {
                    self?.sliderView.isdragging = false
                    self?.player?.play()
                }
            })
        } else {
            self.sliderView.isdragging = false
            self.sliderView.value = 0
        }
    }
    
    
}

