//
//  GestureController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

/// 手势控制器
///
/// 添加单击、双击、拖动手势
class GestureController {
    lazy var singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(GestureController.singleTapAction(_:)))

    lazy var doubleTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(GestureController.doubleTapAction(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()

    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(GestureController.panAction(_:)))

    weak var view: (UIView & Controlable)?

    private var direction: Direction = .horizontal
    // 是否调节音量
    private var isVolume: Bool = false

    init(view: UIView & Controlable) {
        singleTapGesture.require(toFail: doubleTapGesture)

        view.addGestureRecognizer(singleTapGesture)
        view.addGestureRecognizer(doubleTapGesture)
        view.addGestureRecognizer(panGesture)
    }
}

extension GestureController {
    @objc func singleTapAction(_ sender: UITapGestureRecognizer) {
        view?.singleTapAction()
    }

    @objc func doubleTapAction(_ sender: UITapGestureRecognizer) {
        view?.doubleTapAction()
    }

    // TODO: 进度、音量、亮度
    @objc func panAction(_ sender: UIPanGestureRecognizer) {
        let locationPoint = sender.location(in: sender.view)
        let veloctyPoint = sender.velocity(in: sender.view)
        let frame = view?.frame ?? .zero
        switch sender.state {
        case .began:
            let x = abs(veloctyPoint.x)
            let y = abs(veloctyPoint.y)
            if x > y { // 水平移动
                direction = .horizontal
                view?.playTimeWillChange()
            } else if x < y {
                direction = .vertical
                    isVolume = locationPoint.x <= frame.size.width / 2
            }
        case .changed:
            if case .horizontal = direction {
                view?.playTimeDidChange(veloctyPoint.x)
            } else {
                if isVolume {
                    view?.setVolume(veloctyPoint.y)
                } else {
                    view?.setBrightness(veloctyPoint.y)
                }
            }
        case .ended:
            if case .horizontal = direction {
                view?.playTimeEndChange()
            }
        default: break
        }
    }
}

extension GestureController {
    enum Direction {
        case horizontal // 横向
        case vertical // 纵向
    }
}
