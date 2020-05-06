//
//  LandScapeControlView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class LandScapeControlView: UIView, Controlable, NibLoadable {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    var isDragSlider: Bool = false
    var isShowToolBar: Bool = false

    var player: AVPlayer?

    var fullScreen: (() -> Void)?

    private var currentSecond: CGFloat = 0

    deinit {
        print("PortraitControlView_deinit")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
        prepare()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
        prepare()
    }

    func playTimeWillChange() {
        print("快进开始")
        isDragSlider = true
        currentSecond = CGFloat(slider.value)
    }

    func playTimeDidChange(_ value: CGFloat) {
        slider.value = Float(currentSecond + value)
        print("快进改变", value, slider.value)
    }

    func playTimeEndChange() {
        print("快进结束")
        player?.seek(to: CMTimeMakeWithSeconds(Float64(slider.value), preferredTimescale: Int32(NSEC_PER_SEC)), toleranceBefore: .zero, toleranceAfter: .zero)
        isDragSlider = false
    }

    func singleTapAction() {
        if isShowToolBar {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            hideAnimate()
        } else {
            showAnimate()
        }
    }

    func doubleTapAction() {
        print("双击：播放/暂定")
        playAction(playButton)
    }

    func setVolume(_ volume: CGFloat) {
        print("设置音量", volume)
    }

    func setBrightness(_ brightness: CGFloat) {
        print("设置亮度", brightness)
    }

    func playerDidChangedState(_ state: EGPlayer.State) {
        switch state {
        case .loading, .cacheing:
            indicatorView.isHidden = false
        case .playing:
            indicatorView.isHidden = true
            print("播放")
        case .paused:
            print("暂定")
        case .readyToPlay:
            indicatorView.isHidden = true
        case .playEnd:
            player?.seek(to: .zero)
            playButton.isSelected = false
        case .failed(let error):
            break
        }
    }

    func setBuffer(_ buffer: Double) {
        progressView.progress = Float(buffer)
    }

    func setPlayTime(_ time: Double) {
        guard !isDragSlider else { return }
        setCurrentTime(time)
    }

    func setTotalTime(_ time: Double) {
        slider.maximumValue = Float(time)
        totalLabel.text = convertTimeSecond(timeSecond: Int(time))
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

extension LandScapeControlView {
    func prepare() {
        playButton.isSelected = player?.isPlaying ?? false

        slider.maximumTrackTintColor = UIColor.clear
        slider.setMinimumTrackImage(UIColor(hex: 0xEF3D33).asImage(CGSize(width: 20, height: 1.5)), for: .normal)
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
    }

    @IBAction func playAction(_ sender: UIButton) {
        if sender.isSelected {
            player?.pause()
        } else {
            player?.play()
        }
        sender.isSelected = !sender.isSelected
    }

    @IBAction func fullScreenAction(_ sender: UIButton) {
        hideAnimate()
        fullScreen?()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print("valueChanged", sender.value)
        setCurrentTime(Double(sender.value))
    }

    @IBAction func sliderTouchDown(_ sender: UISlider) {
        isDragSlider = true
    }

    @IBAction func sliderTouchUpInSide(_ sender: UISlider) {
        print("TouchUpInSide", sender.value)
        player?.seek(to: CMTimeMakeWithSeconds(Float64(sender.value), preferredTimescale: Int32(NSEC_PER_SEC)), toleranceBefore: .zero, toleranceAfter: .zero)
        isDragSlider = false
    }
}

extension LandScapeControlView {
    func setCurrentTime(_ time: Double) {
        slider.setValue(Float(time), animated: false)
        currentLabel.text = convertTimeSecond(timeSecond: Int(time))
    }

    func showAnimate() {
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.isHidden = false
            self.bottomView.isHidden = false
        }) { (_) in
            self.isShowToolBar = true
            self.perform(#selector(self.hideAnimate), with: nil, afterDelay: 3)
        }
    }

    @objc func hideAnimate() {
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.isHidden = true
            self.bottomView.isHidden = true
        }) { (_) in
            self.isShowToolBar = false
        }
    }
}
