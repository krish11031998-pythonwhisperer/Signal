//
//  Views.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

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
	
	static func flexibleStack(subViews: [UIView], width: CGFloat = .totalWidth) -> UIView {
		let mainStack: UIStackView = .VStack(spacing: 8)
		
		subViews.sizeFittingStack(for: width, with: 8).forEach { row in
			let rowStack = UIView.HStack(subViews: row, spacing: 8)
			rowStack.addArrangedSubview(.spacer())
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

}

extension Array where Element : UIView {
	
	func sizeFittingStack(for width: CGFloat, with spacing: CGFloat = .zero) -> [[UIView]] {
		var result: [[UIView]] = []
		
		var rowStack: [UIView] = []
		var remainingSpace = width
		
		forEach {

			let size = $0.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			let itemSize = remainingSpace
			
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
	
}
