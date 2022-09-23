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
		shape.fillColor = UIColor.black.cgColor
		shape.strokeColor = UIColor.clear.cgColor
		
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
