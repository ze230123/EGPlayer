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
        navigationController?.navigationBar.isHidden = true

        slider.setThumbImage(UIColor.red.asImage(CGSize(width: 14, height: 14)), for: .normal)

        let url = "http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3612804_e50cb68f52adb3c4c3f6135c0edcc7b0_3.mp4"
        player.setUrl(url)
        controlView.backBtnClickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func playAction() {
        player.play()
    }

    @IBAction func pauseAction() {
        player.pause()
    }

    @IBAction func fullAction(_ sender: UIButton) {
        if sender.isSelected {
            setIntface(.portrait)
        } else {
//            setIntface(.landscapeRight)
            enterFull(true)
        }

        sender.isSelected = !sender.isSelected
    }

    func enterFull(_ isFull: Bool) {
        if isFull {
            let window = UIApplication.shared.keyWindow
            let disView = player.displayView

            window?.addSubview(displayView)

            UIView.animate(withDuration: 0.3) {
                disView?.frame = window?.bounds ?? .zero
                self.setIntface(.landscapeRight)
                disView?.layoutIfNeeded()
            }
        } else {
            
        }
    }

    // TODO: 屏幕旋转：1、手动将设备旋转，2、监听系统通知当发生旋转时自动更新布局(2暂时不需要)
    func setIntface(_ orientation: UIInterfaceOrientation) {
        UIView.animate(withDuration: 0.5) {
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            self.view.setNeedsLayout()
        }
    }

    @IBAction func valueChanged(_ sender: UISlider) {
        print(sender.value)
    }
}
// MARK: - 删除
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
