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
            completion?()
        }
        
        let animationData = animation.animationData(at: self)
        finalizePosition(animation: animationData, remove: removeAfterCompletion)
        add(animationData, forKey: nil)
        
        CATransaction.commit()
    }
    
    func multipleAnimation(animation: [Animation], removeAfterCompletion: Bool = false, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            completion?()
        }
        
        let animationData = animation.combine(at: self, removeAfterCompletion: removeAfterCompletion)
        animationData.isRemovedOnCompletion = removeAfterCompletion
        animationData.fillMode = .forwards
        add(animationData, forKey: nil)
        
        CATransaction.commit()
    }
    
    
    func finalizePosition(animation: Animation) {
        finalizePosition(animation: animation.animationData(at: self))
    }
    
    func finalizePosition(animation: CAAnimation, remove: Bool = false) {
        switch animation {
        case let basic as CABasicAnimation:
            basic.isRemovedOnCompletion = remove
            basic.fillMode = .forwards
        case let group as CAAnimationGroup:
            group.isRemovedOnCompletion = remove
            group.fillMode = .forwards
        default: break
        }
    }
}

extension UIView {
    
    func animate(_ animation: Animation, removeAfterCompletion: Bool = false, completion: (() -> Void)? = nil) {
        layer.animate(animation, removeAfterCompletion: removeAfterCompletion, completion: completion)
    }
}
