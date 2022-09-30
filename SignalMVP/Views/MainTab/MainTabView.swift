//
//  MainTabView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

class MainTab: UITabBar {
	
	private var shapeLayer: CAShapeLayer?

	override func draw(_ rect: CGRect) {
		addShape(rect)
	}
	
	private func addShape(_ rect: CGRect) {
		let shape = CAShapeLayer()
		shape.path = drawShape(rect)
		shape.fillColor = UIColor.surfaceBackground.cgColor
		shape.strokeColor = UIColor.clear.cgColor
		shape.shadowColor = UIColor.surfaceBackgroundInverse.cgColor
		shape.shadowOpacity = 0.35
		shape.shadowOffset = .init(width: 0, height: 1.5)
		shape.shadowRadius = 5
		if let oldShape = self.shapeLayer {
			layer.replaceSublayer(oldShape, with: shape)
		} else {
			layer.insertSublayer(shape, at: 0)
		}
		self.shapeLayer = shape
	}
	
	private func drawShape(_ rect: CGRect) -> CGPath {
		let path = UIBezierPath(roundedRect: rect, cornerRadius: 16)
		return path.cgPath
		
	}
	
}
