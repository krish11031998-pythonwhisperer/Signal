//
//  ViewStyling.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 20/09/2022.
//

import Foundation
import UIKit

//MARK: - Corners
enum CornerRadius {
    case top
    case bottom
    case all
    
    var corners: CACornerMask {
        switch self {
        case .top: return [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        case .bottom: return [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        case .all: return [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }
    }
}

//MARK: - UIView+Helpers
extension UIView {
	
	var userInterface: UIUserInterfaceStyle { traitCollection.userInterfaceStyle }
	
	var cornerRadius: CGFloat {
		get { layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}
    
    func cornerRadius(_ value: CGFloat, at corners: CornerRadius) {
        cornerRadius = value
        layer.maskedCorners = corners.corners
    }
    
    var clippedCornerRadius: CGFloat {
        get { cornerRadius }
        set {
            clipsToBounds = true
            cornerRadius = newValue
        }
    }
	
    //func cornerRadius(

	var compressedSize: CGSize {
		systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
	}
	
	func setCompressedSize() {
		let size = compressedSize
		setFrame(width: size.width, height: size.height)
	}

	//MARK: - Circular
	
	var circleFrame: CGRect {
		get { bounds }
		set {
			frame = newValue
			cornerRadius = min(newValue.width, newValue.height).half
			clipsToBounds = true
		}
	}
	
	convenience init(circular: CGRect, background: UIColor) {
		self.init()
		circleFrame = circular
		backgroundColor = background
		clipsToBounds = true
	}
}


//MARK: - UIView+Styling
extension UIView {
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
        self.layer.shadowOpacity = userInterface == .dark ? 0.1 : 0.35
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
}

//MARK: - UIView+GraphicRenderer
extension UIView {
    var snapshot:UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let img =  renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return img
    }
}

