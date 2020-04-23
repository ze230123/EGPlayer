//
//  PlayerViewController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var displayView: DisplayerLayer!

    lazy var controlView = EGPlayerControlView()

    lazy var player = EGPlayer(displayView: displayView, controlView: controlView)

    deinit {
        print("PlayerViewController_deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3612804_e50cb68f52adb3c4c3f6135c0edcc7b0_3.mp4"
        player.setUrl(url)
    }

    @IBAction func playAction() {
        player.play()
    }

    @IBAction func pauseAction() {
        player.pause()
    }
}
