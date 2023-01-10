//
//  CircularProgressShape.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 06/10/2022.
//

import Foundation
import UIKit

fileprivate extension CGRect {
	
	var minDim: CGFloat { min(width, height) }
}

extension CALayer {
	@discardableResult
	func addCircularProgress(startAngle: CGFloat,
							 endAngle: CGFloat,
							 radiusOffset: CGFloat = 0,
							 lineWidth: CGFloat,
							 strokeColor: UIColor,
							 clockwise: Bool,
							 strokeEnd: CGFloat = 1,
							 addTrack: Bool = true,
							 lineCap: CAShapeLayerLineCap = .round,
							 isSemiCircle: Bool = false,
							 animateStrokeEnd: Bool) -> CAShapeLayer {
		let rect = bounds
		let radius = (isSemiCircle ? rect.width : rect.minDim).half + radiusOffset - lineWidth
		let path = UIBezierPath()
		let center: CGPoint = isSemiCircle ? .init(x: rect.midX, y: rect.maxY) : rect.center
		path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
		
		if addTrack {
			let trackShape = CAShapeLayer()
			trackShape.path = path.cgPath
			trackShape.fillColor = UIColor.clear.cgColor
            trackShape.strokeColor = UIColor.gray.withAlphaComponent(0.15).cgColor
			trackShape.lineWidth = lineWidth
			trackShape.strokeStart = 0
			trackShape.strokeEnd = 1
			trackShape.lineCap = lineCap
			addSublayer(trackShape)
		}
		
		let shape = CAShapeLayer()
		shape.path = path.cgPath
		shape.fillColor = UIColor.clear.cgColor
		shape.strokeColor = strokeColor.cgColor
		shape.lineWidth = lineWidth
		shape.strokeStart = 0
		shape.strokeEnd = animateStrokeEnd ? 0 : strokeEnd
		shape.lineCap = lineCap
		addSublayer(shape)
		
		return shape
	}
	
}


class GenericCircularProgressBar: UIView {
	
	private var shape: CAShapeLayer?
	private let startAngle: CGFloat
	private let endAngle: CGFloat
	private let radiusOffset: CGFloat
	private let lineWidth: CGFloat
	private let strokeColor: UIColor
	private let clockwise: Bool
	private let animateStrokeEnd: Bool
	
	init(frame: CGRect,
		 startAngle: CGFloat = -.pi.half,
		 endAngle: CGFloat = 3 * .pi.half,
		 radiusOffset: CGFloat = 0,
		 lineWidth: CGFloat = 1,
		 strokeColor: UIColor,
		 clockwise: Bool = true,
		 strokeEnd: CGFloat,
		 animateStrokeEnd: Bool) {
		self.startAngle = startAngle
		self.endAngle = endAngle
		self.radiusOffset = radiusOffset
		self.lineWidth = lineWidth
		self.strokeColor = strokeColor
		self.clockwise = clockwise
		self.animateStrokeEnd = animateStrokeEnd
		super.init(frame: frame)
		self.shape = layer.addCircularProgress(startAngle: startAngle, endAngle: endAngle, lineWidth: lineWidth,
								  strokeColor: strokeColor, clockwise: clockwise, strokeEnd: strokeEnd, animateStrokeEnd: animateStrokeEnd)
	}
	
	required init?(coder: NSCoder) {
		self.startAngle = 0
		self.endAngle = 2 * .pi
		self.radiusOffset = 0
		self.lineWidth = 1
		self.strokeColor = .clear
		self.clockwise = true
		self.animateStrokeEnd = false
		super.init(coder: coder)
		self.shape = layer.addCircularProgress(startAngle: startAngle, endAngle: endAngle, lineWidth: lineWidth,
								  strokeColor: strokeColor, clockwise: clockwise, animateStrokeEnd: animateStrokeEnd)
	}
	
	func configureChart(to: Float) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.shape?.animate(.circularProgress(to: CGFloat(to), duration: 0.3))
		}
	}
	
}
