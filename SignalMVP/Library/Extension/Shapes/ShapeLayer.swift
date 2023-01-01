//
//  ShapeLayer.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 02/11/2022.
//

import Foundation
import UIKit

//MARK: - Shapes
enum Shapes {
    case circle(color: UIColor, width: CGFloat,
                start: CGFloat = -90.toRadians(),
                end: CGFloat = 270.toRadians(),
                clockwise: Bool = true)
}

extension Shapes {
    
    @discardableResult
    func shapeLayer(at layer: CALayer) -> CAShapeLayer? {
        switch self {
        case .circle(let color, let width, let start, let end, let clockwise):
            let shape = CAShapeLayer()
            let radius = min(layer.frame.width, layer.frame.height).half
            shape.path = UIBezierPath(arcCenter: layer.frame.center, radius: radius, startAngle: start, endAngle: end, clockwise: clockwise).cgPath
            shape.fillColor = UIColor.clear.cgColor
            shape.strokeColor = color.cgColor
            shape.lineWidth = width
            shape.lineJoin = .round
            layer.addSublayer(shape)
            return shape
        }
    }
    
}

//MARK: - CALayer Shape Extension

extension UIView {
    
    private static var animatableShapeKey: UInt8 = 1
    
    private var animatableShape: CAShapeLayer? {
        get { return objc_getAssociatedObject(self, &Self.animatableShapeKey) as? CAShapeLayer }
        set { objc_setAssociatedObject(self, &Self.animatableShapeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @discardableResult
    func addShape(shape: Shapes) -> CAShapeLayer? {
        let resultShape = shape.shapeLayer(at: layer)
        self.animatableShape = resultShape
        return resultShape
    }
    
}
