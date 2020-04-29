//
//  PlayerItemObserver.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerItemObserver {
    /// 手机竖屏时的 控制view
    private weak var portraitControlView: (UIView & Controlable)?
    /// 手机横屏时的 控制view
    private weak var landScapeControlView: (UIView & Controlable)?

    private var loadedTimeRangesObser: NSKeyValueObservation?
    private var stateObserver: NSKeyValueObservation?
    private var totalObserver: NSKeyValueObservation?

    deinit {
        print("PlayerItemObserver_deinit")
    }

    init<V1: UIView, V2: UIView>(portrait: V1, landScape: V2) where V1: Controlable, V2: Controlable {
        self.portraitControlView = portrait
        self.landScapeControlView = landScape
    }
}

extension PlayerItemObserver {
    func addObserver(_ item: AVPlayerItem) {
        /// 缓冲
        loadedTimeRangesObser = item.observe(\.loadedTimeRanges, changeHandler: { [unowned self] (item, _) in
            guard let timeRange = item.loadedTimeRanges.first?.timeRangeValue else { return }
            let startSecounds = timeRange.start.seconds
            let durationSecound = timeRange.duration.seconds
            let cache = startSecounds + durationSecound
            let total = item.duration.seconds
            self.portraitControlView?.setBuffer(cache / total)
            self.landScapeControlView?.setBuffer(cache / total)
        })

        stateObserver = item.observe(\.status, changeHandler: { [unowned self] (item, _) in
            switch item.status {
            case .unknown: break
            case .readyToPlay:
                self.portraitControlView?.playerDidChangedState(.readyToPlay)
                self.landScapeControlView?.playerDidChangedState(.readyToPlay)
            case .failed: break
            @unknown default:
                fatalError()
            }
        })

        totalObserver = item.observe(\.duration) { (item, _) in
            self.portraitControlView?.setTotalTime(item.duration.seconds)
            self.landScapeControlView?.setTotalTime(item.duration.seconds)
        }
    }

    func removeObserver() {
        loadedTimeRangesObser = nil
    }
}
