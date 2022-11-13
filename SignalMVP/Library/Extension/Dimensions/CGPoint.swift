//
//  CGPoint.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit

//MARK: - CGPoint

extension CGPoint {
    
    enum Direction: String {
        case left, right, top, bottom, none
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    var maxMagnitude: CGFloat { max(abs(x), abs(y)) }

    static func swipeDirection(_ a: CGPoint, _ b: CGPoint) -> Direction {
        let diff = a - b
        switch diff.maxMagnitude {
        case abs(diff.x):
            return diff.x < 0 ? .right : .left
        case abs(diff.y):
            return diff.y < 0 ? .top : .bottom
        default:
            return .none
        }
    }
    
}

