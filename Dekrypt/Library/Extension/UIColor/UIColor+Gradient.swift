//
//  UIColor+Gradient.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/01/2023.
//

import Foundation
import UIKit

extension Array where Element == UIColor {
    
    static let gradientColor = [UIColor.clear, UIColor.black.withAlphaComponent(0.25), UIColor.black]
    static let lightGradientColor =  [UIColor.black.withAlphaComponent(0.5), UIColor.clear]
    
}
