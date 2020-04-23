//
//  EGPlayerControlView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class EGPlayerControlView: UIView, NibLoadable {


    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var playerButton: UIButton!

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var allTimeLabel: UILabel!
    @IBOutlet weak var sliderView: EGSliderView!
    
    weak var player: AVPlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }
}

extension EGPlayerControlView: PlayerControlable {
    func playerDidChangedState(_ state: EGPlayer.State) {
        print(state)
    }

    func setCacheProgress(_ progress: Double) {
    }

    func setPlayTime(_ time: Double, total: Double) {
    }
}
    
