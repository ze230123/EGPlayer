//
//  LandScapeControlView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class LandScapeControlView: UIView, NibLoadable {
    var player: AVPlayer?
    var fullScreen: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }
}

extension LandScapeControlView: Controlable {
    func playTimeWillChange() {
    }
    
    func playTimeDidChange(_ value: CGFloat) {
    }
    
    func playTimeEndChange() {
    }

    func singleTapAction() {
        print("显示/隐藏 上下工具栏")
    }

    func doubleTapAction() {
        print("双击：播放/暂定")
    }

    func setVolume(_ volume: CGFloat) {
        print("设置音量", volume)
    }

    func setBrightness(_ brightness: CGFloat) {
        print("设置亮度", brightness)
    }

    func seekSecond(_ second: Double) {
        print("跳转进度", second)
    }

    func playerDidChangedState(_ state: EGPlayer.State) {

    }

    func setBuffer(_ buffer: Double) {
    }

    func setPlayTime(_ time: Double, total: Double) {

    }
}
