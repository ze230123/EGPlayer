//
//  NewFullViewController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/29.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class NewFullViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
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
