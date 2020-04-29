//
//  Controlable.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import Foundation
import AVFoundation

protocol Controlable: class {
    var player: AVPlayer? { get set }

    // 全屏事件
    var fullScreen: (() -> Void)? { get set }
    
    func singleTapAction()

    func doubleTapAction()

    // 设置音量
    func setVolume(_ volume: CGFloat)
    // 设置亮度
    func setBrightness(_ brightness: CGFloat)

    // 播放状态改变
    func playerDidChangedState(_ state: EGPlayer.State)
    // 设置播放时间，视频总时长
    func setPlayTime(_ time: Double)
    func setTotalTime(_ time: Double)
    // 设置缓冲进度
    func setBuffer(_ buffer: Double)

    func playTimeWillChange()
    func playTimeDidChange(_ value: CGFloat)
    func playTimeEndChange()
}
