//
//  EGPlayerGestureControl.swift
//  EGPlayer
//
//  Created by Jason on 2020/4/24.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit

class EGPlayerGestureControl: NSObject {
    
    
    private lazy var singleTap: UITapGestureRecognizer = {
       let singleTap = UITapGestureRecognizer()
        singleTap.delegate = self
        singleTap.delaysTouchesBegan = true
        singleTap.delaysTouchesEnded = true
        singleTap.numberOfTouchesRequired = 1
        return singleTap
    }()
    

}

extension EGPlayerGestureControl: UIGestureRecognizerDelegate {
    
}


extension EGPlayerGestureControl {
    
    enum GestureType: Int {
        case unknown
        case singleTap
        case doubleTap
        case pan
        case pinch
    }
    
    enum PanDirection: Int {
        case unknown
        case V
        case H
    }
    
    enum PanLoacation {
        case unknown
        case left
        case right
    }
    
    struct DisableGestureTypes : OptionSet {
        let rawValue: UInt
        static let none = DisableGestureTypes(rawValue: 0)
        static let singleTap =  DisableGestureTypes(rawValue: 1 << 0)
        static let doubleTap =  DisableGestureTypes(rawValue: 1 << 1)
        static let pan =  DisableGestureTypes(rawValue: 1 << 2)
        static let pinch =  DisableGestureTypes(rawValue: 1 << 3)
        static let all = [singleTap, doubleTap, pan, pinch]
    }
    
 
}
