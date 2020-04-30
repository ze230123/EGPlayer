//
//  NewFullViewController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/29.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class NewFullViewController: UIViewController {

    var callback: (() -> Void)?

    init(callback: @escaping () -> Void) {
        self.callback = callback
        super.init(nibName: "NewFullViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
    }

    @IBAction func closeAction() {
        callback?()
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }

}
