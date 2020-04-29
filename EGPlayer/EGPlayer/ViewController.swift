//
//  ViewController.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/22.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapAction() {
        let vc = NormalPlayerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func windowAction() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowLevel = .alert
        window?.isHidden = false
        window?.backgroundColor = UIColor.green
        window?.rootViewController = NewFullViewController()
//        window?.makeKeyAndVisible()
    }

    @IBAction func closeAction() {
        window = nil
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

import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.white
    @IBInspectable var endColor: UIColor = UIColor.white

    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        //使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //颜色数组（这里使用三组颜色作为渐变）fc6820

        let compoents: [CGFloat] = colors.map { $0.components }.compactMap { $0 }.reduce([], +)
        //没组颜色所在位置（范围0~1)
        let locations: [CGFloat] = [0, 1]
        //生成渐变色（count参数表示渐变个数）
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                  locations: locations, count: locations.count)!
        //渐变开始位置
        let start = CGPoint(x: rect.width * startPoint.x, y: rect.height * startPoint.y)
        //渐变结束位置
        let end = CGPoint(x: rect.width * endPoint.x, y: rect.height * endPoint.y)
        //绘制渐变
        context.drawLinearGradient(gradient, start: start, end: end,
                                   options: .drawsBeforeStartLocation)
    }
}

private extension GradientView {
    var colors: [CGColor] {
        return [startColor.cgColor, endColor.cgColor]
    }
}
