//
//  PortraitControlView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class PortraitControlView: UIView, NibLoadable {
    var player: AVPlayer?
    var fullScreen: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }
}

extension PortraitControlView: Controlable {
    func playTimeWillChange() {
    }
    
    func playTimeDidChange(_ value: CGFloat) {
    }
    
    func playTimeEndChange() {
    }
    
    func singleTapAction() {
    }
    
    func doubleTapAction() {
    }

    func setVolume(_ volume: CGFloat) {

    }

    func setBrightness(_ brightness: CGFloat) {

    }

    func seekSecond(_ second: Double) {

    }

    func playerDidChangedState(_ state: EGPlayer.State) {

    }

    func setBuffer(_ buffer: Double) {
    }

    func setPlayTime(_ time: Double, total: Double) {

    }
}
