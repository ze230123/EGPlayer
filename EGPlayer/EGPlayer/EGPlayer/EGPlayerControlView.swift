//
//  EGPlayerControlView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class EGPlayerControlView: UIView, PlayerControlable {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var playerButton: UIButton!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var allTimeLabel: UILabel!
    @IBOutlet weak var sliderView: EGSliderView!
    
    weak var player: AVPlayer?

    
    static var nib: UINib? {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

}
    
