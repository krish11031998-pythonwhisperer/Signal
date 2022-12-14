//
//  Views.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

//MARK: - UIView
extension UIView {

	static func HStack(subViews: [UIView] = [], spacing: CGFloat, alignment: UIStackView.Alignment = .fill) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: subViews)
		stack.spacing = spacing
		stack.alignment = alignment
		return stack
	}
	
	static func VStack(subViews: [UIView] = [], spacing: CGFloat, alignment: UIStackView.Alignment = .fill) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: subViews)
		stack.axis = .vertical
		stack.spacing = spacing
		stack.alignment = alignment
		return stack
	}
	
	static func flexibleStack(subViews: [UIView], width: CGFloat = .totalWidth) -> UIStackView {
        let mainStack: UIStackView = .VStack(spacing: 8, alignment: .leading)
		
		subViews.sizeFittingStack(for: width, with: 8).forEach { row in
			let rowStack = UIView.HStack(subViews: row, spacing: 8)
			mainStack.addArrangedSubview(rowStack)
		}
		
		return mainStack
	}
	
	static func emptyViewWithColor(color: UIColor = .clear, width: CGFloat? = nil, height: CGFloat? = nil) ->  UIView {
		let blankView = UIView()
		blankView.backgroundColor = .clear
		if let validHeight = height {
			blankView.setHeight(height: validHeight, priority: .required)
		}
		
		if let validWidth = width {
			blankView.setWidth(width: validWidth, priority: .required)
		}
		
		return blankView
	}
    
    static func solidColorView(frame: CGRect, backgroundColor: UIColor) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = backgroundColor
        return view
    }
}

//MARK: - UIView+Gradients

enum GradientDirection {
    case up, down, left, right, acrossLeftToRight, acrossRightToLeft
}
extension UIView {
    func gradient(color: [UIColor], direction: GradientDirection) -> CALayer {
        let gradient: CAGradientLayer = .init()
        gradient.colors = color.compactMap { $0.cgColor }
        gradient.frame = bounds
        gradient.startPoint = .zero
        switch direction {
        case .up:
            gradient.startPoint = .init(x: 0, y: 1)
            gradient.endPoint = .init(x: 0, y: 0)
        case .down:
            gradient.startPoint = .init(x: 0, y: 0)
            gradient.endPoint = .init(x: 0, y: 1)
        case .left:
            gradient.startPoint = .init(x: 0, y: 0)
            gradient.endPoint = .init(x: 1, y: 0)
        case .right:
            gradient.startPoint = .init(x: 1, y: 0)
            gradient.endPoint = .init(x: 0, y: 0)
        case .acrossLeftToRight:
            gradient.startPoint = .zero
            gradient.endPoint = .init(x: 1, y: 1)
        case .acrossRightToLeft:
            gradient.startPoint = .init(x: 1, y: 1)
            gradient.endPoint = .zero
        }
        return gradient
    }
}

//MARK: - UIView + Array<UIView>
extension Array where Element : UIView {
	
	func sizeFittingStack(for width: CGFloat, with spacing: CGFloat = .zero) -> [[UIView]] {
		var result: [[UIView]] = []
		
		var rowStack: [UIView] = []
		var remainingSpace = width
		
		forEach {

			let size = $0.compressedSize
			
			if size.width == width {
				result.append([$0])
			} else if size.width >= remainingSpace {
				if !rowStack.isEmpty { result.append(rowStack) }
				rowStack.removeAll()
				remainingSpace = width
			}
			
			rowStack.append($0)
			remainingSpace -= size.width + spacing
		}
		
		if !rowStack.isEmpty { result.append(rowStack) }
		
		return result
	}
    
    func addToView(_ main: UIView, removeChildren: Bool = false) {
        if removeChildren {
            main.removeChildViews()
        }
        if let stack = main as? UIStackView {
            forEach(stack.addArrangedSubview(_:))
        } else {
            forEach(main.addSubview(_:))
        }
    }
    
	
    func embedInVStack(alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stack = UIStackView.VStack(subViews: self, spacing: spacing, alignment: alignment)
        stack.distribution = distribution
        return stack
    }
    
    
    func embedInHStack(alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stack = UIStackView.HStack(subViews: self, spacing: spacing, alignment: alignment)
        stack.distribution = distribution
        return stack
    }
}


//MARK: - UIView Modifiers
extension UIView {
    func buttonify(bouncyEffect: Bool = true, handler: Callback?) -> UIView {
        return GenericButtonWrapper(innerView: self, bouncyEffect: bouncyEffect, handler: handler)
    }
    
    func hideChildViews() {
        var views: [UIView] = subviews
        switch self {
        case let stack as UIStackView:
            views = stack.arrangedSubviews
        default: break
        }
        views.forEach { $0.isHidden = true }
    }
}
