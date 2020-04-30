//
//  DisplayerLayer.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

/// 显示画面View
class DisplayerLayer: UIView {
    var parentView: UIView?
    var tempFrame: CGRect = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    func setPlayer(_ player: AVPlayer?) {
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
    }

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            playerLayer.render(in: rendererContext.cgContext)
        }
    }
}

private extension DisplayerLayer {
    func prepare() {
        backgroundColor = .black
    }
}
