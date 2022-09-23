//
//  ViewStyling.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 20/09/2022.
//

import Foundation
import UIKit

extension UIView {
	
	var cornerRadius: CGFloat {
		get { layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}
	
	func border(color: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat? = nil) {
		layer.borderColor = color.cgColor
		layer.borderWidth = borderWidth
		
		if let validCornerRadius = cornerRadius {
			self.cornerRadius = validCornerRadius
		}
	}
	
	func addBlurView(_ style: UIBlurEffect.Style = .dark) {
		let blur = UIBlurEffect(style: style)
		let blurView = UIVisualEffectView(effect: blur)
		addSubview(blurView)
		setFittingConstraints(childView: blurView, insets: .zero)
		sendSubviewToBack(blurView)
	}
	
	
	var compressedSize: CGSize {
		systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
	}
	
	func setCompressedSize() {
		let size = compressedSize
		setFrame(width: size.width, height: size.height)
	}

	//MARK: - Circular
	
	var cornerFrame: CGRect {
		get { bounds }
		set {
			frame = newValue
			cornerRadius = min(newValue.width, newValue.height).half
			clipsToBounds = true
		}
	}
	
	convenience init(circular: CGRect, background: UIColor) {
		self.init()
		cornerFrame = circular
		backgroundColor = background
		clipsToBounds = true
	}
}

