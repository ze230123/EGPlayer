//
//  EGPlayer.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

//typedef NS_ENUM(NSInteger, NIAVPlayerStatus) {
//    NIAVPlayerStatusLoading = 0,     // 加载视频
//    NIAVPlayerStatusReadyToPlay,     // 准备好播放
//    NIAVPlayerStatusIsPlaying,       // 正在播放
//    NIAVPlayerStatusIsPaused,        // 已经暂停
//    NIAVPlayerStatusPlayEnd,         // 播放结束
//    NIAVPlayerStatusCacheData,       // 缓冲视频
//    NIAVPlayerStatusCacheEnd,        // 缓冲结束
//    NIAVPlayerStatusPlayStop,        // 播放中断 （多是没网）
//    NIAVPlayerStatusItemFailed,      // 视频资源问题
//    NIAVPlayerStatusEnterBack,       // 进入后台
//    NIAVPlayerStatusBecomeActive,    // 从后台返回
//};


class EGPlayer {
    let player = AVPlayer()

    var displayView: DisplayerLayer!
    var controlView: (UIView & PlayerControlable)!

    init<V: UIView>(controlView: V) where V: PlayerControlable {
        displayView = DisplayerLayer()
        self.controlView = controlView
        controlView.player = player
        layoutControl(controlView)
        prepare()
    }

    init<V: UIView>(displayView: DisplayerLayer, controlView: V) where V: PlayerControlable {
        self.displayView = displayView
        self.controlView = controlView
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

    var timeObserverToken: Any?

    var loadedTimeRangesObser: NSKeyValueObservation?

    var timeControlStatusObser: NSKeyValueObservation?
}

extension EGPlayer {
    func addKVO(item: AVPlayerItem) {
        /// 缓冲
        loadedTimeRangesObser = item.observe(\.loadedTimeRanges, changeHandler: { (item, _) in
            guard let timeRange = item.loadedTimeRanges.first?.timeRangeValue else { return }
            let startSecounds = timeRange.start.seconds
            let durationSecound = timeRange.duration.seconds
            let cache = startSecounds + durationSecound
            let total = item.duration.seconds
            self.controlView.setCacheProgress(cache / total)
        })

        timeControlStatusObser = player.observe(\.timeControlStatus) { [unowned self] (item, _) in
            switch item.timeControlStatus {
            case .paused:
                self.controlView.playerDidChangedState(.paused)
            case .playing:
                self.controlView.playerDidChangedState(.playing)
            case .waitingToPlayAtSpecifiedRate:
                self.controlView.playerDidChangedState(.cache)
            @unknown default:
                fatalError()
            }
        }
    }

    func removeKVO() {
        loadedTimeRangesObser = nil
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
        addPlayerNotification()

        /// 播放时间
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [unowned self] (time) in
            let currentTime = time.seconds
            let totalTime = self.player.currentItem?.duration.seconds ?? 0
            self.controlView.setPlayTime(currentTime, total: totalTime)
        }
    }

    func addPlayerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(playFinish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playError), name: Notification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
    }

    @objc func playFinish() {
        print("播放完成")
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
    }

    @objc func playError() {
        guard let error = player.error else { return }
        controlView.playerDidChangedState(.failed(error))
        print("播放失败", error.localizedDescription)
    }
}

extension EGPlayer {
    enum State {
        case loading, readyToPlay, playing, paused, playEnd, cache, cacheEnd, failed(Error)
    }
}
