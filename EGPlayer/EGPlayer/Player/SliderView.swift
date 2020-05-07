//
//  SliderView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/28.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class Slider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 2, y: (bounds.height - 1.5) / 2, width: bounds.width, height: 1.5)
    }
}
