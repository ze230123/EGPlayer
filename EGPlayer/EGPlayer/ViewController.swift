//
//  ViewController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/22.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapAction() {
        let vc = PlayerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

