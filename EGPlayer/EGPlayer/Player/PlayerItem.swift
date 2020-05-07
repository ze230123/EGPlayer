//
//  PlayerItem.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/5/7.
//  Copyright © 2020 youzy. All rights reserved.
//

import Foundation

struct PlayerItem {
    /// 播放地址
    var url: String = ""
    var tryTime: Double = 0
    var state: State = .normal
}

extension PlayerItem {
    enum State {
        /// 正常可播放
        case normal
        /// 视频已下线
        case offline
        /// 付费购买
        case buy
        /// VIP可播放
        case vip
    }
}
