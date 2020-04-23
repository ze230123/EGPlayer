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
        prepare()
    }

    init<V: UIView>(displayView: DisplayerLayer, controlView: V) where V: PlayerControlable {
        self.displayView = displayView
        controlView.player = player
        layoutControl(controlView)
        prepare()
    }

    /// 播放
    func play() {
        player.play()
    }

    /// 暂停
    func pause() {
        player.pause()
    }

    func setUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        removeKVO()
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        addKVO(item: item)
    }

    var statusObser: NSKeyValueObservation?
    var timeObserverToken: Any?

    var loadedTimeRangesObser: NSKeyValueObservation?
}

extension EGPlayer {
    func addKVO(item: AVPlayerItem) {
        /// item状态
        statusObser = item.observe(\.status, changeHandler: { (item, _) in
            print(item.status.rawValue)
        })
        /// 缓冲
        loadedTimeRangesObser = item.observe(\.loadedTimeRanges, changeHandler: { (item, _) in
            guard let timeRange = item.loadedTimeRanges.first?.timeRangeValue else { return }
            let startSecounds = timeRange.start.seconds
            let durationSecound = timeRange.duration.seconds
            let cache = startSecounds + durationSecound
            let total = item.duration.seconds
            print("缓冲", cache, total, cache / total)
        })
    }

    func removeKVO() {
        statusObser = nil
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

    func prepare() {
        displayView.setPlayer(player)
        /// 播放时间
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [unowned self] (time) in
            let currentTime = time.seconds
            let totalTime = self.player.currentItem?.duration.seconds ?? 0
            print(currentTime, totalTime, Float(currentTime / totalTime))
        }
    }
}
