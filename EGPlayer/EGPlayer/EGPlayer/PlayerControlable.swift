//
//  PlayerControlable.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerControlable: class {
    var player: AVPlayer? { get set }
    /// 播放状态改变
    func playerDidChangedState(_ state: EGPlayer.State)
    /// 设置缓冲进度
    func setCacheProgress(_ progress: Double)
    /// 设置播放时间，视频总时长
    func setPlayTime(_ time: Double, total: Double)
}
