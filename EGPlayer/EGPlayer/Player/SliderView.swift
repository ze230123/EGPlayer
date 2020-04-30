//
//  SliderView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/28.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
@IBDesignable
class SliderView: UIView {
    lazy var progressView = UIProgressView()
    lazy var slider = UISlider()

    var buffer: CGFloat = 0

    var minValue: CGFloat = 0 {
        didSet {
            slider.minimumValue = Float(minValue)
        }
    }

    var maxValue: CGFloat = 1 {
        didSet {
            slider.maximumValue = Float(maxValue)
        }
    }

    var value: CGFloat = 0 {
        didSet {
            slider.value = Float(value)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    override func prepareForInterfaceBuilder() {
        maxValue = 100
        minValue = 0
        value = 30
        buffer = 50
    }
}

extension SliderView {
    func prepare() {
        progressView.progressTintColor = UIColor(hex: 0xCCCCCC)
        progressView.trackTintColor = UIColor(hex: 0xFFFFFF, alpha: 0.3)
        addSubview(progressView)
        progressView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        progressView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true

        slider.maximumTrackTintColor = UIColor.clear
        slider.setMinimumTrackImage(UIColor(hex: 0xEF3D33).asImage(CGSize(width: 20, height: 1.5)), for: .normal)
        addSubview(slider)

        slider.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        slider.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        slider.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
