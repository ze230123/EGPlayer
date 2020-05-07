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
    var actionBlock: (() -> Void)?

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fullButton: UIButton!

    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var tipsButton: UIButton!

    deinit {
        print("PlayerTipsView_deinit")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
    }

    func setState(_ state: PlayerItem.State) {
        tipsButton.isHidden = state == .offline

        switch state {
        case .buy:
            tipsLabel.text = "该内容需购买后观看"
        case .vip:
            tipsLabel.text = "该内容需购买VIP会员后观看"
        case .offline:
            tipsLabel.text = "该内容已下架"
        default:
            break
        }
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
        actionBlock?()
    }
}
