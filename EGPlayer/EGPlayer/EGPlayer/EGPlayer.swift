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
    let player = AVPlayer()

    var displayView = DisplayerLayer()

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

    func setUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
    }
}
