//
//  RateListView.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/5/8.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class RateListView: UIView, NibLoadable {
    private var current: UIButton?
    private let rate: Float

    var didSelect: ((Float) -> Void)?
    var closeBlock: ((RateListView) -> Void)?

    deinit {
        print("RateListView_deinit")
    }

    init(rate: Float) {
        self.rate = rate
        super.init(frame: .zero)
        initViewFromNib()
        prepare()
    }

    override init(frame: CGRect) {
        rate = 1
        super.init(frame: frame)
        initViewFromNib()
        prepare()
    }

    required init?(coder: NSCoder) {
        rate = 1
        super.init(coder: coder)
        initViewFromNib()
        prepare()
    }

    func show(in view: UIView?) {
        guard let view = view  else { return }
        frame = view.bounds
        transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        view.addSubview(self)

        UIView.animate(withDuration: 0.5, animations: {
            self.transform = .identity
        }) { (_) in
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}

extension RateListView {
    func prepare() {
        guard let tag = tagForRate(rate) else { return }
        current = viewWithTag(tag) as? UIButton
        current?.isSelected = true
    }

    @IBAction func tapAction(_ sender: UIButton) {
        guard !sender.isSelected else { return }
        guard let rate = rateForTag(sender.tag) else { return }
        current?.isSelected = false
        sender.isSelected = true
        current = sender
        didSelect?(rate)
    }

    @IBAction func closeAction() {
        closeBlock?(self)
    }

    func rateForTag(_ tag: Int) -> Float? {
        switch tag {
        case 101:
            return 0.5
        case 102:
            return 0.75
        case 103:
            return 1
        case 104:
            return 1.25
        case 105:
            return 1.5
        case 106:
            return 2
        default:
            return nil
        }
    }

    func tagForRate(_ rate: Float) -> Int? {
        switch rate {
        case 0.5:
            return 101
        case 0.75:
            return 102
        case 1:
            return 103
        case 1.25:
            return 104
        case 1.5:
            return 105
        case 2:
            return 106
        default:
            return nil
        }
    }
}
