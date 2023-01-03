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
        let animationData = animation.animationData(at: self)
        
        CATransaction.setCompletionBlock {
            self.finalizePosition(animation: animation, data: animationData, remove: removeAfterCompletion)
            completion?()
        }
        
        animationData.isRemovedOnCompletion = false
        animationData.fillMode = .forwards
        add(animationData, forKey: animation.name)
        
        CATransaction.commit()
    }
    
    func multipleAnimation(animation: [Animation], removeAfterCompletion: Bool = false, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        
        let animationData = animation.combine(at: self, removeAfterCompletion: removeAfterCompletion)
        
        CATransaction.setCompletionBlock {
            self.finalizePosition(animations: animation,
                                  data: animationData,
                                  remove: removeAfterCompletion)
            completion?()
        }
        
        
        animationData.isRemovedOnCompletion = removeAfterCompletion
        animationData.fillMode = .forwards
        add(animationData, forKey: nil)
        
        CATransaction.commit()
    }
    
    func finalizePosition(animations: [Animation], data: CAAnimation, remove: Bool) {
        animations.forEach { anim in
            finalizePosition(animation: anim, data: data, remove: remove)
        }
    }
    
    func finalizePosition(animation: Animation, data: CAAnimation, remove: Bool) {
        switch animation {
        case .fadeOut, .fadeIn, .transformX:
            finalizePosition(animation: data,
                             remove: remove)
            self.removeAllAnimations()
        default:
            break
        }
        
    }
    
    func finalizePosition(animation: CAAnimation, remove: Bool = false) {
        switch animation {
        case let basic as CABasicAnimation:
            guard let keyPath = basic.keyPath else { return }
            asyncMain {
                self.setValue(basic.toValue, forKeyPath: keyPath)
            }
        case let group as CAAnimationGroup:
            group.animations?.forEach { finalizePosition(animation: $0, remove: remove)}
        default: break
        }
    }
    
}

extension UIView {
    
    func animate(_ animation: Animation, removeAfterCompletion: Bool = false, completion: (() -> Void)? = nil) {
        layer.animate(animation, removeAfterCompletion: removeAfterCompletion, completion: completion)
    }
}
