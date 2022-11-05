//
//  CALayer+Animation.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 05/11/2022.
//

import Foundation
import UIKit

extension CALayer {
    
    func animate(_ animation: Animation, removeAfterCompletion: Bool = false, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
//            if !removeAfterCompletion {
//                self.finalizePosition(animation: animation)
//            }
            completion?()
        }
        
        let animationData = animation.animationData(at: self)
        animationData.isRemovedOnCompletion = false
        animationData.fillMode = .forwards
        add(animationData, forKey: nil)
        
        CATransaction.commit()
    }
    
    func multipleAnimation(animation: [Animation], removeAfterCompletion: Bool = false, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
//            if !removeAfterCompletion {
//                animation.forEach(self.finalizePosition(animation:))
//            }
            completion?()
        }
        
        let animationData = animation.combine(at: self, removeAfterCompletion: removeAfterCompletion)
        animationData.isRemovedOnCompletion = false
        animationData.fillMode = .forwards
        add(animationData, forKey: nil)
        
        CATransaction.commit()
    }
    
    
    func finalizePosition(animation: Animation) {
        finalizePosition(animation: animation.animationData(at: self))
    }
    
    func finalizePosition(animation: CAAnimation) {
        switch animation {
        case let basic as CABasicAnimation:
            guard let keyPath = basic.keyPath else { return }
            setValue(basic.toValue, forKeyPath: keyPath)
            print("(DEBUG) updating @ \(keyPath) - \(value(forKeyPath: keyPath))")
        case let group as CAAnimationGroup:
            group.animations?.forEach(finalizePosition(animation:))
        default: break
        }
    }
}

extension UIView {
    
    func animate(_ animation: Animation, removeAfterCompletion: Bool = false, completion: (() -> Void)? = nil) {
        layer.animate(animation, removeAfterCompletion: removeAfterCompletion, completion: completion)
    }
}
