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
    private var portraitControlView: (UIView & Controlable)
    /// 手机横屏时的 控制view
    private var landScapeControlView: (UIView & Controlable)

    private var loadedTimeRangesObser: NSKeyValueObservation?

    init<V: UIView>(portrait: V, landScape: V) where V: Controlable {
        self.portraitControlView = portrait
        self.landScapeControlView = landScape
    }
}

private extension PlayerItemObserver {
    func addObserver(_ item: AVPlayerItem) {
        /// 缓冲
        loadedTimeRangesObser = item.observe(\.loadedTimeRanges, changeHandler: { [unowned self] (item, _) in
            guard let timeRange = item.loadedTimeRanges.first?.timeRangeValue else { return }
            let startSecounds = timeRange.start.seconds
            let durationSecound = timeRange.duration.seconds
            let cache = startSecounds + durationSecound
            let total = item.duration.seconds
            self.portraitControlView.setBuffer(cache / total)
            self.landScapeControlView.setBuffer(cache / total)
        })
    }

    func removeObserver() {
        loadedTimeRangesObser = nil
    }
}
