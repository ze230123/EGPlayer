//
//  EGPlayerControlView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class EGPlayerControlView: UIView, NibLoadable, PlayerControlable {

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
    
    weak var player: AVPlayer?
    
    var totalTime: TimeInterval {
        return CMTimeGetSeconds(self.player?.currentItem?.duration ?? CMTime.zero)
    }
    
    var currentTime: TimeInterval {
        return CMTimeGetSeconds(self.player?.currentItem?.currentTime() ?? CMTime.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }
    
}

///竖屏方法
extension EGPlayerControlView {
     private func addSubviewActions() {
         self.playerButton.addTarget(self, action: #selector(playPauseButtonClickAction), for: .touchUpInside)
         self.showButton.addTarget(self, action: #selector(fullScreenButtonClickAction), for: .touchUpInside)
     }
     
    @objc func playPauseButtonClickAction() {
     
         
     }
     
    @objc func fullScreenButtonClickAction() {
         
     }
     
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

/// controlView 方法
extension EGPlayerControlView {
    
    func hideAllControlView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.hideControlView()
        }) { (finished) in
            print(finished)
        }
    }
    
    func showAllControlView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.showControlView()
        }) { (finished) in
            print(finished)
        }
    }
}

///PlayerControlable 协议方法
extension EGPlayerControlView {
    
    /// 播放失败
    func playFaild(error: Error) {
    }
    
    /// 视频需要缓冲
    func playDidCache() {
    }
    
    /// 视频可以播放
    func playDidCanPlay() {
        hideAllControlView()
    }

    func playerDidChangedState(_ state: EGPlayer.State) {
        print(state)
    }

    func setCacheProgress(_ progress: Double) {
    }

    func setPlayTime(_ time: Double, total: Double) {
    }
}

extension EGPlayerControlView: EGSliderViewDelegate {
    
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
    
