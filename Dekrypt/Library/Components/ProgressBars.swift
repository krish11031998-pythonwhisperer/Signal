//
//  ProgressBars.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

class ProgressBar: UIView {
	
	private var addedLayers: Bool = false
	private var bgColor: UIColor = .clear
	private var fillColor: UIColor = .clear
	private var borderColor: UIColor = .clear
	
	
	private lazy var progressShape: CAShapeLayer = {
		let progressbar = CAShapeLayer()
		progressbar.fillColor = fillColor.cgColor
		progressbar.strokeColor = UIColor.clear.cgColor
		progressbar.lineWidth = 0
		return progressbar
	}()
	
	private lazy var borderShape: CAShapeLayer = {
		let borderShape = CAShapeLayer()
		borderShape.fillColor = bgColor.cgColor
		borderShape.strokeColor = borderColor.cgColor
		borderShape.lineWidth = 2
		borderShape.lineJoin = .round
		return borderShape
	}()
	
	init(bgColor: UIColor = .gray.withAlphaComponent(0.35), borderColor: UIColor = .white.withAlphaComponent(0.7), fillColor: UIColor = .white) {
		super.init(frame: .zero)
		self.bgColor = bgColor
		self.borderColor = borderColor
		self.fillColor = fillColor
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		addLayers()
	}
	
	func addLayers() {
		guard !addedLayers else { return }
		borderShape.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
		progressShape.path = UIBezierPath(roundedRect: .init(origin: bounds.origin, size: .init(width: 0, height: bounds.height)),
										  cornerRadius: 12).cgPath
		layer.addSublayer(borderShape)
		layer.addSublayer(progressShape)
		
		addedLayers.toggle()
	}
	
	func animateProgress(progress: CGFloat = 0.5) {
		let newPath = UIBezierPath(roundedRect: .init(origin: .zero, size: .init(width: bounds.width * progress, height: bounds.height)),
								   cornerRadius: 12).cgPath

		let anim = CABasicAnimation(keyPath: "path")
		anim.toValue = newPath
		anim.duration = 0.5
		anim.isRemovedOnCompletion = false
		anim.fillMode = .forwards
		
		progressShape.add(anim, forKey: nil)
	}
	
}
