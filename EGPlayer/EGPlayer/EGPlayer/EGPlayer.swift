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

    var displayView: DisplayerLayer!

    init<V: UIView>(controlView: V) where V: PlayerControlable {
        displayView = DisplayerLayer()
        controlView.player = player
        layoutControl(controlView)
    }

    init<V: UIView>(displayView: DisplayerLayer, controlView: V) where V: PlayerControlable {
        self.displayView = displayView
        controlView.player = player
        layoutControl(controlView)
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

extension EGPlayer {
    func layoutControl(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        displayView.addSubview(view)
        view.topAnchor.constraint(equalTo: displayView.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: displayView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: displayView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
    }
}
