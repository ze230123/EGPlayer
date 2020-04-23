//
//  EGPlayer.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class EGPlayer {
    var player: AVPlayer?

    lazy var displayView = DisplayerLayer()

    init(controlView: UIView & PlayerControlable) {
        controlView.translatesAutoresizingMaskIntoConstraints = false
        displayView.addSubview(controlView)
        controlView.topAnchor.constraint(equalTo: displayView.topAnchor).isActive = true
        controlView.leftAnchor.constraint(equalTo: displayView.leftAnchor).isActive = true
        controlView.rightAnchor.constraint(equalTo: displayView.rightAnchor).isActive = true
        controlView.bottomAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
    }

    /// 播放
    func play() {
    }

    /// 暂停
    func pause() {
    }

    /// 播放URL
    func playForUrl(_ url: String) {
    }

    /// 替换当前播放的URL
    func replaceCurrentUrl(_ url: String) {
    }
}
