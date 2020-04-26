//
//  EGPlayerGestureControl.swift
//  EGPlayer
//
//  Created by Jason on 2020/4/24.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class EGPlayerGestureControl: NSObject {
    
    var singleTapped: ((_ control: EGPlayerGestureControl) -> Void)?
    var beganPan: ((_ control: EGPlayerGestureControl, _ derection: PanDirection, _ location: PanLoacation) -> Void)?
    var changedPan: ((_ control: EGPlayerGestureControl, _ derection: PanDirection, _ location: PanLoacation, _ velocity: CGPoint) -> Void)?
    var endedPan: ((_ control: EGPlayerGestureControl, _ derection: PanDirection, _ location: PanLoacation) -> Void)?
    
    var targetView: UIView?
    var disablePanMovingDirection: DisablePanMovingDirection = .none
//    var disableTypes: DisableGestureTypes = .none
    var panLocation: PanLoacation = .unknown
    var panDirection: PanDirection = .unknown
    var panMovingDirection: MovingDirection = .unknown
    
    func addGestureToView(view: UIView) {
        self.targetView = view
        self.targetView?.isMultipleTouchEnabled = true
        self.singleTap.require(toFail: self.panGR)
        self.targetView?.addGestureRecognizer(self.singleTap)
        self.targetView?.addGestureRecognizer(self.panGR)
    }
    
    func removeGestureToView(view: UIView) {
        view.removeGestureRecognizer(self.singleTap)
        view.removeGestureRecognizer(self.panGR)
    }


    
    
    @objc func handleSingleTap(_ tap: UITapGestureRecognizer) {

        self.singleTapped?(self)
    }
    
    @objc func handlePan(_ pan: UIPanGestureRecognizer) {
        let translate = pan.translation(in: pan.view)
        let velocity = pan.velocity(in: pan.view)
        switch pan.state {
        case .began:
            let x = abs(velocity.x)
            let y = abs(velocity.y)
            if x > y {
                self.panDirection = .H
            } else if x < y {
                self.panDirection = .V
            } else {
                self.panDirection = .unknown
            }
            self.beganPan?(self,self.panDirection,self.panLocation)
        case .changed:
            switch self.panDirection {
            case .H:
                if translate.x > 0{
                    self.panMovingDirection = .right
                } else if translate.y < 0 {
                    self.panMovingDirection = .left
                }
            case .V:
                if translate.y > 0 {
                    self.panMovingDirection = .bottom
                } else {
                    self.panMovingDirection = .top
                }
            default:
                break
            }
            self.changedPan?(self, self.panDirection, self.panLocation, velocity)
        case .ended:
            self.endedPan?(self, self.panDirection, self.panLocation)
        default:
            break
        }
        
        pan.setTranslation(CGPoint.zero, in: pan.view)
        
    }
    
    private lazy var singleTap: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleSingleTap(_ :)))
        singleTap.delegate = self
        singleTap.delaysTouchesBegan = true
        singleTap.delaysTouchesEnded = true
        singleTap.numberOfTouchesRequired = 1
        return singleTap
    }()
    
    private lazy var panGR: UIPanGestureRecognizer = {
       let panGR = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(_ :)))
        panGR.delegate = self
        panGR.delaysTouchesBegan = true
        panGR.delaysTouchesEnded = true
        panGR.maximumNumberOfTouches = 1
        panGR.cancelsTouchesInView = true
        return panGR
    }()
    

    

}

extension EGPlayerGestureControl: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGR {
            if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
                let translation = panGesture.translation(in: self.targetView)
                let x = abs(translation.x)
                let y = abs(translation.y)
                if (x < y && self.disablePanMovingDirection.contains(.vertical)) { /// up and down moving direction.
                    return false
                } else if (x > y && self.disablePanMovingDirection.contains(.horizontal)) { /// left and right moving direction.
                    return false
                }
                
            }
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let locationPoint = touch.location(in: touch.view)
        self.panLocation = locationPoint.x > (self.targetView?.bounds.size.width ?? 0) / 2 ? .right : .left
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if otherGestureRecognizer != self.singleTap && otherGestureRecognizer != self.panGR {
            return false
        }
        
        if gestureRecognizer == self.panGR {
            if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
                let translation = panGesture.translation(in: self.targetView)
                let x = abs(translation.x)
                let y = abs(translation.y)
                if (x < y && self.disablePanMovingDirection.contains(.vertical)) {
                    return true
                } else if (x > y && self.disablePanMovingDirection.contains(.horizontal)) {
                    return true
                }
                
            }
        }
        
        if gestureRecognizer.numberOfTouches >= 2 {
            return false
        }

        return true
    }
    
}


extension EGPlayerGestureControl {
    
//    enum GestureType: Int {
//        case unknown
//        case singleTap
//        case doubleTap
//        case pan
//        case pinch
//    }
    
    enum PanDirection: Int {
        case unknown
        case V
        case H
    }
    
    enum PanLoacation: Int {
        case unknown
        case left
        case right
    }
    
    enum MovingDirection: Int {
        case unknown
        case top
        case left
        case bottom
        case right
        
    }
    
//    struct DisableGestureTypes : OptionSet {
//        let rawValue: UInt
//        static let none = DisableGestureTypes(rawValue: 0)
//        static let singleTap =  DisableGestureTypes(rawValue: 1 << 0)
//        static let doubleTap =  DisableGestureTypes(rawValue: 1 << 1)
//        static let pan =  DisableGestureTypes(rawValue: 1 << 2)
//        static let pinch =  DisableGestureTypes(rawValue: 1 << 3)
//        static let all = [singleTap, doubleTap, pan, pinch]
//    }
    
    struct DisablePanMovingDirection : OptionSet {
        let rawValue: UInt
        static let none = DisablePanMovingDirection(rawValue: 0)
        static let vertical =  DisablePanMovingDirection(rawValue: 1 << 0)
        static let horizontal =  DisablePanMovingDirection(rawValue: 1 << 1)
        static let all = [vertical, horizontal]
    }
 
}
