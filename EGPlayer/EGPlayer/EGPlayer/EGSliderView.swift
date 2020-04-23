//
//  EGSliderView.swift
//  EGPlayer
//
//  Created by Jason on 2020/4/23.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

protocol EGSliderViewDelegate {
    ///滑块滑动开始
    func sliderTouchBegan(value: TimeInterval)
    /// 滑块滑动中
    func sliderValueChanged(value: TimeInterval)
    /// 滑块滑动结束
    func sliderTouchEnded(value: TimeInterval)
    /// 滑杆点击
    func sliderTapped(value: TimeInterval)
    
}

///进度条
class EGSliderView: UIView, NibLoadable {
    
    ///底部view
    @IBOutlet weak var bgProgressView: UIView!
    
    ///缓冲进度view
    @IBOutlet weak var bufferProgressView: UIView!
    @IBOutlet weak var bufferWith: NSLayoutConstraint!
    
    ///播放进度view
    @IBOutlet weak var sliderProgressView: UIView!
    @IBOutlet weak var sliderWidth: NSLayoutConstraint!
    ///滑块view
    @IBOutlet weak var sliderView: UIView!
    
    /// 是否正在拖动
    var isdragging: Bool = false
    
    var delegate: EGSliderViewDelegate?
    
    
    ///滑竿进度
    var value: CGFloat = 0 {
        
        didSet{
            sliderWidth.constant = value * self.bounds.width
        }
    }
    
    ///缓冲进度
    var bufferValue: CGFloat = 0 {
        didSet {
            bufferWith.constant = bufferValue * self.bounds.width

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
        addOtherActions()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewFromNib()
        addOtherActions()

    }
    
    // MARK: - User action
    func addOtherActions() {
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapped(_ :)))
        self.addGestureRecognizer(tapGesture)
        
        // 添加滑动手势
        let sliderGesture = UIPanGestureRecognizer.init(target: self, action: #selector(sliderGesture(_ :)))
        self.addGestureRecognizer(sliderGesture)
        
    }
    
    @objc func tapped(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: bgProgressView)
        var value = (point.x - sliderView.bounds.width * 0.5) * 1.0 / bgProgressView.bounds.width
        value = value > 1.0 ? 1.0 : value <= 0 ? 0 : value
        self.value = value
        self.delegate?.sliderTapped(value: TimeInterval(value))
        
    }
    
    @objc func sliderGesture(_ gesture: UIGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            sliderBtnTouchBegin(view: sliderView)
        case .changed:
            sliderBtnDragMoving(view: sliderView, touchpoint: gesture.location(in: bgProgressView))
        case .ended:
            sliderBtnTouchEnded(view: sliderView)
        default:
            break
        }
        
    }
    
    private func sliderBtnTouchBegin(view: UIView) {
        self.delegate?.sliderTouchBegan(value: TimeInterval(self.value))
        UIView.animate(withDuration: 0.3) {
            view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }
    }
    
    private func sliderBtnTouchEnded(view: UIView) {
        self.delegate?.sliderTouchEnded(value: TimeInterval(self.value))
        
        UIView.animate(withDuration: 0.3) {
            view.transform = CGAffineTransform.identity
        }

    }
    
    private func sliderBtnDragMoving(view: UIView, touchpoint: CGPoint) {
        let point = touchpoint
        var value = point.x - view.bounds.width * 0.5 / bgProgressView.bounds.width
        value = value > 1.0 ? 1.0 : value <= 0.0 ? 0.0 : value
        if self.value == value {
            return
        }
        self.value = value
        self.delegate?.sliderValueChanged(value: TimeInterval(value))
        
    }
    

    
}
