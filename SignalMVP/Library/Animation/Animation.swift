//
//  Animation.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

enum AnimationDirection {
    case up
    case down
    case left
    case right
}

enum Animation {
	case slideInFromTop(from: CGFloat, to:CGFloat = 0, duration: CFTimeInterval = 0.3)
    case slideIn(_ direction: AnimationDirection, duration: CFTimeInterval = 0.3)
	case circularProgress(from: CGFloat = 0, to: CGFloat, duration: CFTimeInterval = 0.3)
    case lineProgress(frame: CGRect, duration: CFTimeInterval = 0.3)
    case fadeIn
    case fadeOut(to: CGFloat = 0)
}

extension Animation {
	
	func animationData(at layer: CALayer) -> CAAnimation {
		
		switch self {
		case .slideInFromTop(let from, let to, let duration):
			let animation = CABasicAnimation(keyPath: "position.y")
			animation.fromValue = from
			animation.toValue = to

			let opacity = CABasicAnimation(keyPath: "opacity")
			opacity.fromValue = 0
			opacity.toValue = 1
			
			let group = CAAnimationGroup()
			group.animations = [animation, opacity]
			group.duration = duration
			
			return group
        case .slideIn(let direction, let  duration):
            let animation = CABasicAnimation(keyPath: "position.y")

            switch direction {
                case .up:
                    animation.fromValue = -layer.frame.height
                    animation.toValue = 0
                case .down:
                    animation.fromValue = .totalHeight + layer.frame.height
                    animation.toValue = 0
                default: break;
            }
            
            let opacity = CABasicAnimation(keyPath: "opacity")
            opacity.fromValue = 0
            opacity.toValue = 1

            
            let group = CAAnimationGroup()
            group.animations = [animation, opacity]
            group.duration = duration
        
            return group
		case .circularProgress(let from, let to, let duration):
			let animation = CABasicAnimation(keyPath: "strokeEnd")
			animation.fromValue = from
			animation.toValue = to
			animation.duration = duration
			
			return animation
        case .lineProgress(let frame, let duration):
            let animation = CABasicAnimation(keyPath: "path")
            animation.toValue = UIBezierPath(roundedRect: frame, cornerRadius: frame.size.smallDim.half).cgPath
            animation.duration = duration
            return animation
        case .fadeIn:
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.toValue = 1
            animation.duration = 0.3
            return animation
        case .fadeOut(let to):
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.toValue = to
            animation.duration = 0.3
            return animation
		}
		
	}
	
    static func combining(at layer: CALayer, animation: [Animation], removeAfterCompletion: Bool = false ) -> CAAnimation {
        let group = CAAnimationGroup()
        group.animations = animation.compactMap { $0.animationData(at: layer)}
        return group
    }
}

extension Array where Element == Animation {
    
    func combine(at layer: CALayer, removeAfterCompletion: Bool) -> CAAnimation {
        Animation.combining(at: layer, animation: self, removeAfterCompletion: removeAfterCompletion)
    }
    
}
