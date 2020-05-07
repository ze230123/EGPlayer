//
//  PlayerTipsView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/5/7.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class PlayerTipsView: UIView, NibLoadable, TipsControlable {
    var fullScreen: ((Bool) -> Void)?
    var isFullScreen: Bool = false

    var closeBlock: (() -> Void)?

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fullButton: UIButton!

    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var tipsButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }

    func setState(_ state: PlayerItem.State) {
    }
}

extension PlayerTipsView {
    func prepare() {
    }

    @IBAction func closeAction() {
        if isFullScreen {
            fullScreen?(isFullScreen)
        } else {
            closeBlock?()
        }
    }

    @IBAction func fullAction() {
        fullScreen?(isFullScreen)
    }

    @IBAction func tipsAction() {
    }
}
