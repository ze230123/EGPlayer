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
    func singleTapAction() {
    }
    
    func doubleTapAction() {
    }
    
    func setVolume(_ volume: Double) {

    }

    func setBrightness(_ brightness: Double) {

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
