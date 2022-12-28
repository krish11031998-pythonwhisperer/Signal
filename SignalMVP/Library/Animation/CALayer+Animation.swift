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
        print("(DEBUG) calling Animate!")
        CATransaction.begin()
        
        let animationData = animation.animationData(at: self)
        CATransaction.setCompletionBlock {
            self.finalizePosition(animation: animation, remove: removeAfterCompletion)
            print("(DEBUG) completion is Called!")
            completion?()
        }
        
        add(animationData, forKey: nil)
//        animationData.isRemovedOnCompletion = removeAfterCompletion
//        animationData.fillMode = .forwards
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
    
    func finalizePosition(animation: Animation, remove: Bool) {
        finalizePosition(animation: animation.animationData(at: self), remove: remove)
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
