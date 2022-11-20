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
	private var borderWidth: CGFloat = 1
    private var ratio: CGFloat = 0
	
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
		borderShape.lineWidth = borderWidth
		borderShape.lineJoin = .round
		return borderShape
	}()
	
	init(bgColor: UIColor = .gray.withAlphaComponent(0.35),
		 fillColor: UIColor = .surfaceBackgroundInverse,
		 borderWidth: CGFloat = 1,
		 borderColor: UIColor = .white.withAlphaComponent(0.7)) {
		super.init(frame: .zero)
		self.bgColor = bgColor
		self.borderColor = borderColor
		self.borderWidth = borderWidth
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
		if ratio != 0 {
			animateProgress()
		}
		addedLayers.toggle()
	}
	
	func animateProgress() {
		let newSize: CGSize = .init(width: bounds.width * ratio, height: bounds.height)
		let newPath = UIBezierPath(roundedRect: .init(origin: .zero, size: newSize),
								   cornerRadius: 12).cgPath

		let anim = CABasicAnimation(keyPath: "path")
		anim.toValue = newPath
		anim.duration = 0.5
		anim.isRemovedOnCompletion = false
		anim.fillMode = .forwards
		
		progressShape.add(anim, forKey: nil)
	}
	
	func setProgress(progress: CGFloat, color: UIColor? = nil) {
		self.ratio = progress
		if let validColor = color {
			fillColor = validColor
		}
        animateProgress() 
	}
	
}


//MARK: - ProgressBar Array Extension

extension Array where Element == ProgressBar {
    
    func animateSequentially(ratios: [CGFloat]) {
        guard count == ratios.count else { return }
        zip(self,ratios).enumerated().forEach {
            let (bar, progress) = $0.element
            let delay = 0.5 * Double($0.offset)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                bar.setProgress(progress: progress)
            }
        }
    }
    
}
