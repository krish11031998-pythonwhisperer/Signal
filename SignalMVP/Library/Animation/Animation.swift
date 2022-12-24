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

enum AnimationState {
    case `in`
    case out
}

enum Animation {
    case bouncy
	case slideInFromTop(from: CGFloat, to:CGFloat = 0, duration: CFTimeInterval = 0.3)
    case slide(_ direction: AnimationDirection, state: AnimationState = .in, duration: CFTimeInterval = 0.3)
	case circularProgress(from: CGFloat = 0, to: CGFloat, duration: CFTimeInterval = 0.3)
    case lineProgress(frame: CGRect, duration: CFTimeInterval = 0.3)
    case fadeIn(duration: CFTimeInterval = 0.3)
    case fadeOut(to: CGFloat = 0, duration: CFTimeInterval = 0.3)
    case slideUpDown(duration: CGFloat = 0.3)
    case fadeInOut(duration: CGFloat = 0.75)
}

extension Animation {
	
	func animationData(at layer: CALayer) -> CAAnimation {
		
		switch self {
        case .bouncy:
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.keyTimes = [0, 0.33, 0.66, 1]
            animation.values = [1, 0.975, 0.975, 1]
            return animation
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
        case .slide(let direction, let state, let  duration):
            let animation = CABasicAnimation(keyPath: "position.y")

            switch direction {
                case .up:
                animation.fromValue = state == .in ? -layer.frame.height : layer.frame.height
                animation.toValue = state == .in ? layer.frame.height : -layer.frame.height
                case .down:
                animation.fromValue = .totalHeight + layer.frame.height.half * (state == .in ? 1 : -1)
                animation.toValue = .totalHeight + layer.frame.height.half * (state == .in ? -1 : 1)
                default: break;
            }
            
            let opacity = CABasicAnimation(keyPath: "opacity")
            opacity.fromValue = 1
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
        case .fadeIn(let duration):
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.toValue = 1
            animation.duration = duration
            return animation
        case .fadeOut(let to, let duration):
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.toValue = to
            animation.duration = duration
            return animation
        case .fadeInOut(let duration):
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.keyTimes = [0, 0.15, 0.5, 0.85, 1]
            animation.values = [0, 0.75, 1, 0.75, 0]
            animation.duration = duration
            return animation
        case .slideUpDown(let duration):
            let animation = CAKeyframeAnimation(keyPath: "position.y")
            animation.keyTimes = [0, 0.3, 0.6, 1]
            animation.values = [-5, 0, 5, 0]
            animation.autoreverses = true
            animation.repeatCount = .infinity
            //animation.isRemovedOnCompletion = false
            animation.duration = duration
            return animation
		}
		
	}
	
    static func combining(at layer: CALayer, animation: [Animation], removeAfterCompletion: Bool = false ) -> CAAnimation {
        let group = CAAnimationGroup()
        group.animations = animation.compactMap { $0.animationData(at: layer)}
        return group
    }
    
    var name: String {
        switch self {
        case .bouncy:
            return "bouncy"
        case .slideInFromTop:
            return "slideInFromTop"
        case .slide:
            return "slide"
        case .circularProgress:
            return "circularProgress"
        case .lineProgress:
            return "lineProgress"
        case .fadeIn:
            return "fadeIn"
        case .fadeOut:
            return "fadeOut"
        case .slideUpDown:
            return "slideUpDown"
        case .fadeInOut:
            return "fadeInOut"
        }
    }
}

extension Array where Element == Animation {
    
    func combine(at layer: CALayer, removeAfterCompletion: Bool) -> CAAnimation {
        Animation.combining(at: layer, animation: self, removeAfterCompletion: removeAfterCompletion)
    }
    
}
