//
//  UIImageView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

extension UIImageView {
    
    convenience init(size: CGSize, cornerRadius: CGFloat, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init(frame: size.frame)
        backgroundColor = .gray.withAlphaComponent(0.25)
        clippedCornerRadius = cornerRadius
        setFrame(size)
        self.contentMode = contentMode
    }
    
    convenience init(circleFrame: CGRect, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init()
        backgroundColor = .gray.withAlphaComponent(0.25)
        cornerRadius = circleFrame.size.smallDim.half
        setFrame(circleFrame.size)
        self.contentMode = contentMode
    }
}

