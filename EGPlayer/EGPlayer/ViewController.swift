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

    override var shouldAutorotate: Bool {
        return false
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
}


protocol NibLoadable: class {
    func loadViewFromNib(name: String) -> UIView
    func initViewFromNib(name: String, enabled: Bool)
}

extension NibLoadable where Self: UIView {

    func loadViewFromNib(name: String = "") -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)

        var nibName: String = ""
        if !name.isEmpty {
            nibName = name
        } else {
            nibName = NSStringFromClass(className).components(separatedBy: ".").last ?? ""
        }
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    func initViewFromNib(name: String = "", enabled: Bool = true) {
        let contentView = loadViewFromNib(name: name)
        contentView.isUserInteractionEnabled = enabled
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    //在协议里面不允许定义class 只能定义static
    static func loadFromNib(_ nibname: String? = nil) -> Self {//Self (大写) 当前类对象
        //self(小写) 当前对象
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
