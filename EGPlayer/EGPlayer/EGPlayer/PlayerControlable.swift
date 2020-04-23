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

    /// 播放失败
    func playFaild(error: Error)
    /// 视频需要缓冲
    func playDidCache()
    /// 视频可以播放
    func playDidCanPlay()

    func setCacheProgress(_ progress: Double)
    func setPlayTime(_ time: Double, total: Double)

    func playStatueDidChanged()
}
