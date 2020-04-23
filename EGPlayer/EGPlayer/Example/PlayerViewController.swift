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
    @IBOutlet weak var slider: UISlider!

    lazy var controlView = EGPlayerControlView()

    lazy var player = EGPlayer(displayView: displayView, controlView: controlView)

    deinit {
        print("PlayerViewController_deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.setThumbImage(UIColor.red.asImage(CGSize(width: 14, height: 14)), for: .normal)

        let url = "http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3612804_e50cb68f52adb3c4c3f6135c0edcc7b0_3.mp4"
        player.setUrl(url)
    }

    @IBAction func playAction() {
        player.play()
    }

    @IBAction func pauseAction() {
        player.pause()
    }

    @IBAction func valueChanged(_ sender: UISlider) {
        print(sender.value)
    }
}


extension UIColor {
        func asImage(_ size: CGSize) -> UIImage? {
            
            var resultImage: UIImage? = nil
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                
                return resultImage
            }
            
            context.setFillColor(self.cgColor)
            context.fill(rect)
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resultImage
        }
}
