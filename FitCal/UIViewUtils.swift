//
//  AnimationUtils.swift
//  FitCal
//
//  Created by Natalia Consonni on 1/7/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit

extension UIView {

    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 3
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }

}
