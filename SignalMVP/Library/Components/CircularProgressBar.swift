//
//  CircularProgressBar.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit

class CircularProgressbar: UIView {
	
	private lazy var innerText: UILabel = { .init() }()
	private var circularPathLayer: CAShapeLayer?
	private var circularChartAdded: Bool = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	private func setupView() {
		addSubview(innerText)
		setFittingConstraints(childView: innerText, centerX: 0, centerY: 0)
		innerText.textAlignment = .center
		clipsToBounds = true
	}
	
	private func setupProgressBar() {
		circularPathLayer = CAShapeLayer()
		let radius = min(frame.width, frame.height).half - 1
		let circularPath = UIBezierPath(arcCenter: frame.center, radius: radius,
										startAngle: CGFloat(-90.0).toRadians(),
										endAngle: CGFloat(270).toRadians(),
										clockwise: true)
		
		circularPathLayer?.path = circularPath.cgPath
		circularPathLayer?.fillColor = UIColor.gray.withAlphaComponent(0.2).cgColor
		circularPathLayer?.borderColor = UIColor.clear.cgColor
		circularPathLayer?.strokeStart = 0
		circularPathLayer?.strokeEnd = 0
		circularPathLayer?.lineWidth = 1
		circularPathLayer?.strokeColor = UIColor.white.cgColor
		
		layer.addSublayer(circularPathLayer ?? CAShapeLayer())
		circularChartAdded.toggle()
	}
	
	public func configureChart(label: RenderableText? = nil, color: UIColor, _ val: CGFloat, visited: Bool) {
		if let layer = layer.sublayers?.filter({ $0 === circularPathLayer }).first {
			layer.removeFromSuperlayer()
		}
		if !circularChartAdded {
			setupProgressBar()
			circularChartAdded.toggle()
		}
		if let validLabel = label {
			validLabel.render(target: innerText)
		} else {
			(String(format: "%.0f", val * 100) + "%").styled(font: .systemFont(ofSize: 12, weight: .regular)).render(target: innerText)
		}
		
		circularPathLayer?.strokeColor = color.cgColor
		if visited {
			circularPathLayer?.strokeEnd = val
		}
	}
	
	public func animateValue(color: UIColor,_ val: CGFloat) {
		circularPathLayer?.animate(animation: .circularProgress(to: val, duration: 0.75))
	}
}
