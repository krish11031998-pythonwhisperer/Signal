//
//  CGRect.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 12/11/2022.
//

import Foundation
import UIKit

extension CGRect {
    
    var relativeFrame: CGRect {
        let originX = origin.x
        let originY = origin.y
        
        return .init(origin: .init(x: originX.truncatingRemainder(dividingBy: CGFloat.totalWidth) , y: originY.truncatingRemainder(dividingBy: CGFloat.totalHeight)), size: size)
    }
    
}
