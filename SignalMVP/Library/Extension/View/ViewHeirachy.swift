//
//  ViewHeirachy.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 19/09/2022.
//

import Foundation
import UIKit

extension UIView {
	
	static func divider() -> UIView {
		let view = UIView()
		view.setFrame(height: 0.75)
		view.backgroundColor = .surfaceBackgroundInverse
		return view
	}
	
	static func spacer(width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
		let view = UIView()
		view.setFrame(width: width, height: height)
		return view
	}
	
	static func divider(color: UIColor = .gray, height: CGFloat = 0.5) -> UIView {
		let divider = UIView()
		divider.backgroundColor = color
		divider.setHeight(height: height, priority: .required)
		return divider
	}
	
	func setFittingConstraints(childView: UIView, insets: UIEdgeInsets) {
		let items: [NSLayoutConstraint] = [
			childView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
			childView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
			childView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
			childView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
		]
		
		childView.translatesAutoresizingMaskIntoConstraints = false
		removeSimilarConstraints(items)
		addConstraints(items)
	}
	
	func setFittingConstraints(childView: UIView,
							   top: CGFloat? = nil,
							   leading: CGFloat? = nil,
							   trailing: CGFloat? = nil,
							   bottom: CGFloat? = nil,
							   width: CGFloat? = nil,
							   height: CGFloat? = nil,
							   centerX: CGFloat? = nil,
							   centerY: CGFloat? = nil,
							   priority: UILayoutPriority = .required) {
		var items: [NSLayoutConstraint] = []
		
		if let validLeading = leading { items.append(childView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: validLeading)) }
		if let validTop = top { items.append(childView.topAnchor.constraint(equalTo: topAnchor, constant: validTop)) }
		if let validBottom = bottom { items.append(childView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -validBottom)) }
		if let validTrailing = trailing { items.append(childView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -validTrailing)) }
		if let validHeight = height { items.append(childView.heightAnchor.constraint(equalToConstant: validHeight)) }
		if let validWidth = width { items.append(childView.widthAnchor.constraint(equalToConstant: validWidth)) }
		if let validCenterX = centerX { items.append(childView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: validCenterX)) }
		if let validCenterY = centerY { items.append(childView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: validCenterY)) }
		
		items.forEach {
			$0.priority = priority
		}
		
		childView.translatesAutoresizingMaskIntoConstraints = false
		removeSimilarConstraints(items)
		addConstraints(items)
	}
	
	func setFrame(_ size: CGSize) {
		setFrame(width: size.width, height: size.height)
	}
	
	func setFrame(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let validWidth = width {
            setWidth(width: validWidth, priority: .required)
        }
        if let validHeight = height {
            setHeight(height: validHeight, priority: .required)
        }
        
	}
	
	func removeSimilarConstraints(_ list: [NSLayoutConstraint]) {
		constraints.forEach {
			guard let const = list.filter($0.isSame(constraint:)).first else { return }
			removeConstraint(const)
		}
	}
	
    func embedInView(insets: UIEdgeInsets, priority: UILayoutPriority = .required) -> UIView {
		let view = UIView()
		view.addSubview(self)
		view.setFittingConstraints(childView: self, top: insets.top, leading: insets.left, trailing: insets.right, bottom: insets.bottom, priority: priority)
		return view
	}
	
	func setWidth(width: CGFloat, priority: UILayoutPriority) {
		let constraint = widthAnchor.constraint(equalToConstant: width)
		removeSimilarConstraints([constraint])
		constraint.priority = priority
		constraint.isActive = true
        frame.size.width = width
	}
	
	func setHeight(height: CGFloat, priority: UILayoutPriority) {
		let constraint = heightAnchor.constraint(equalToConstant: height)
		removeSimilarConstraints([constraint])
		constraint.priority = priority
		constraint.isActive = true
        frame.size.height = height
	}
	
	func removeChildViews() {
		if let stack = self as? UIStackView{
			stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
		} else {
			subviews.forEach { $0.removeFromSuperview() }
		}
	}
}

extension NSLayoutConstraint {
	
	func isSame(constraint: NSLayoutConstraint) -> Bool {
		firstAnchor === constraint.firstAnchor &&
		secondAnchor === constraint.secondAnchor &&
		firstItem === constraint.firstItem &&
		secondItem === constraint.secondItem
	}
}

extension UILayoutPriority {
	static var needed: Self { .init(999) }
}
