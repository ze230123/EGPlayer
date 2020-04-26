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
    func sliderTouchBegan()
    /// 滑块滑动中
    func sliderValueChanged(value: Double)
    /// 滑块滑动结束
    func sliderTouchEnded(value: Double)
    /// 滑杆点击
    func sliderTapped(value: Double)
    
}

///进度条
class EGSliderView: UIView, NibLoadable {
    
    ///底部view
    @IBOutlet weak var bgProgressView: UIView!
    
    @IBOutlet weak var sliderView: UISlider!
    
    @IBOutlet weak var bufferWith: NSLayoutConstraint!
    
    @IBOutlet weak var progress: UIProgressView!
    
    /// 是否正在拖动
    var isdragging: Bool = false
    
    var delegate: EGSliderViewDelegate?
    var totalTime: Float = 0 {
        didSet {
            self.sliderView.maximumValue = self.totalTime
        }
    }
    
    ///滑竿进度
    var value: Float = 0 {
        
        didSet{
            sliderView.value = self.value
        }
    }
        
    ///缓冲进度
    var bufferValue: CGFloat = 0 {
        didSet {
            progress.progress = Float(bufferValue)

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
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappeds(_ :)))
        self.addGestureRecognizer(tapGesture)
        
        sliderView.addTarget(self, action: #selector(sliderBtnTouchBegin(_ :)), for: .touchDown)
        sliderView.addTarget(self, action: #selector(sliderBtnDragMoving(_ :)), for: .valueChanged)
        sliderView.addTarget(self, action: #selector(sliderBtnTouchEnded(_ :)), for: .touchUpInside)
        
    }
    
    @objc func tappeds(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: bgProgressView)
        var value = Float(point.x / bgProgressView.bounds.width) * self.totalTime
        let totalTime = Float(self.totalTime)
        value = value > totalTime ? totalTime : value <= 0 ? 0 : value
        self.value = value
        self.delegate?.sliderTapped(value: Double(value))

    }
    
    
    @objc func sliderBtnTouchBegin(_ slider: UISlider) {
        self.delegate?.sliderTouchBegan()
        
    }

    @objc func sliderBtnTouchEnded(_ slider: UISlider) {
        self.delegate?.sliderTouchEnded(value: Double(slider.value))

    }
    
    @objc func sliderBtnDragMoving(_ slider: UISlider) {
        var value = slider.value
        let totalTime = Float(self.totalTime)
        value = value > totalTime ? totalTime : value <= 0 ? 0 : value
        if self.value == Float(value) {
            return
        }
        self.value = Float(value)
        self.delegate?.sliderValueChanged(value: Double(value))
        
    }
    
}
