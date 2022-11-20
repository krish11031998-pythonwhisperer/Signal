//
//  MutlipleStrokeCircularProgressBar.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 19/10/2022.
//

import Foundation
import UIKit

struct MultipleStrokeCircularProgressBarModel {
	let color: UIColor
	let end: CGFloat
}

class MultipleStrokeCircularProgressBar: UIView {
	
	private let start: CGFloat
	private let end: CGFloat
	private let strokeWidth: CGFloat
	private let radiusOffset: CGFloat
	private let clockwise: Bool
	private let isSemiCircle: Bool
	private var addedlayer: Bool = false
	private var strokes: [CAShapeLayer] = []

	
	init(start: CGFloat,
		 end: CGFloat,
		 frame: CGRect,
		 strokeWidth: CGFloat = 10,
		 radiusOffset: CGFloat = -10,
		 clockwise: Bool = true,
		 isSemiCircle: Bool = true) {
		self.start = start
		self.end = end
		self.strokeWidth = strokeWidth
		self.radiusOffset = radiusOffset
		self.clockwise = clockwise
		self.isSemiCircle = isSemiCircle
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

	}
	
	private func setupView() {
		layer.addCircularProgress(startAngle: start.toRadians(),
								  endAngle: end.toRadians(),
								  radiusOffset: radiusOffset,
								  lineWidth: strokeWidth,
								  strokeColor: userInterface == .light ? .white : .black,
								  clockwise: true,
								  isSemiCircle: isSemiCircle,
								  animateStrokeEnd: false)
	}
	
	public func setupChart(model: [MultipleStrokeCircularProgressBarModel]) {
		strokes = model.map {
			layer.addCircularProgress(startAngle: start.toRadians(),
									  endAngle: $0.end.toRadians(),
									  radiusOffset: radiusOffset,
									  lineWidth: strokeWidth,
									  strokeColor: $0.color,
									  clockwise: clockwise,
									  addTrack: false,
									  isSemiCircle: isSemiCircle,
									  animateStrokeEnd: true)
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.strokes.forEach {
				$0.animate(.circularProgress(to: 1))
			}
		}
	}
}
