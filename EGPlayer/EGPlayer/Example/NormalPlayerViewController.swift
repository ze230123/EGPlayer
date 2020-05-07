//
//  NormalPlayerViewController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/28.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class NormalPlayerViewController: UIViewController {
    @IBOutlet weak var displayView: UIView!

    lazy var player = Player(contentView: displayView, portrait: PortraitControlView(), landScape: LandScapeControlView(), tipsView: PlayerTipsView())

    deinit {
        player.stop()
        print("NormalPlayerViewController_deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3612804_e50cb68f52adb3c4c3f6135c0edcc7b0_3.mp4"
        let item = PlayerItem(url: url, tryTime: 5, state: .buy)
        player.setItem(item)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}
