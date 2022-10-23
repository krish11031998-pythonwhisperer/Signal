//
//  ViewStyling.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 20/09/2022.
//

import Foundation
import UIKit

extension UIView {
	
	var userInterface: UIUserInterfaceStyle { traitCollection.userInterfaceStyle }
	
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
	
	var defaultBlurStyle: UIBlurEffect.Style {
		userInterface == .light ? .systemThinMaterialLight : .systemUltraThinMaterialDark
	}
	
	func addBlurView(_ _style: UIBlurEffect.Style? = nil) {
		let style = _style ?? defaultBlurStyle
		let blur = UIBlurEffect(style: style)
		let blurView = UIVisualEffectView(effect: blur)
		addSubview(blurView)
		setFittingConstraints(childView: blurView, insets: .zero)
		sendSubviewToBack(blurView)
	}
	
	func addShadow(){
		self.layer.shadowColor = UIColor.surfaceBackgroundInverse.cgColor
		self.layer.shadowOpacity = 0.1
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = 2
	}
	
	func addShadowBackground(inset: UIEdgeInsets = .zero, cornerRadius: CGFloat = 8) {
		let view = UIView()
		view.addShadow()
		view.border(color: .clear, borderWidth: 1, cornerRadius: cornerRadius)
		addSubview(view)
		sendSubviewToBack(view)
		setFittingConstraints(childView: view, insets: inset)
	}
	
	var compressedSize: CGSize {
		systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
	}
	
	func setCompressedSize() {
		let size = compressedSize
		setFrame(width: size.width, height: size.height)
	}
	
	//MARK: - GraphicRenderer
	var snapshot:UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds)
		let img =  renderer.image { context in
			layer.render(in: context.cgContext)
		}
		return img
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

