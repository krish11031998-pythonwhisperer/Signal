//
//  RatingChartCandle.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 05/11/2022.
//

import Foundation
import UIKit

enum RatingChartCandleFillMode {
    case topBottom
    case bottomTop
}

class RatingChartCandle: UIView {
    
    private let size: CGSize
    private let color: UIColor
    private let factor: CGFloat
    private let fillMode: RatingChartCandleFillMode
    
    init(factor: CGFloat, color: UIColor, size: CGSize, fillMode: RatingChartCandleFillMode) {
        self.factor = factor
        self.color = color
        self.size = size
        self.fillMode = fillMode
        super.init(frame: .init(origin: .zero, size: size))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = color.withAlphaComponent(0.3)
        clippedCornerRadius = size.smallDim.half
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.setupShape()
        }
        layer.opacity = 0
    }
    
    private func setupShape() {
        let shape = CAShapeLayer()
        let origin: CGPoint = fillMode == .bottomTop ? .init(x: 0, y: frame.maxY) : .zero
        let size: CGSize = .init(width: frame.width, height: frame.height * factor)
        
        let factorView = UIView()
        addSubview(factorView)
        if fillMode == .bottomTop {
            setFittingConstraints(childView: factorView, bottom: 0, width: size.width, height: size.height)
        } else {
            setFittingConstraints(childView: factorView, top: 0, width: size.width, height: size.height)
        }
        
        
        shape.path = UIBezierPath(roundedRect: .init(origin: origin, size: .zero), cornerRadius: size.smallDim.half).cgPath
        shape.fillColor = color.cgColor
        
        factorView.layer.addSublayer(shape)
        
        shape.animate(.lineProgress(frame: .init(origin: .zero, size: size)))
        layer.animate(.fadeIn)
    }
}
