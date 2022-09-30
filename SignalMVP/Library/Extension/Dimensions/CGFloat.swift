//
//  CGFloat.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 20/09/2022.
//

import Foundation
import UIKit

public extension UIApplication {
	
	static var main: UIApplication? { UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication }
}

extension CGFloat {
	
	static var totalWidth: CGFloat { UIScreen.main.bounds.width }
	static var totalHeight: CGFloat { UIScreen.main.bounds.height }
	
	static var safeAreaInsets: UIEdgeInsets {
		let windows = UIApplication.main?.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows
		return (windows?.first(where: { $0.isKeyWindow }) ?? windows?.last)?.safeAreaInsets ?? .zero
	}
	
	var half: Self { self * 0.5 }
	
	func toRadians() -> CGFloat {
		(self * .pi)/180
	}
	
	func replaceWithMin(_ val: CGFloat) -> CGFloat { self > val ? self : val }
	
	func boundTo(lower: CGFloat = 0, higher: CGFloat = 1) -> CGFloat { self > higher ? higher : self < lower ? lower : self }
}

extension ClosedRange where Bound == CGFloat {
	
	func percent(_ val: CGFloat) -> CGFloat {
		let min = lowerBound
		let max = upperBound
		return (val - min)/(max - min)
	}
}

extension CGRect {
	
	var center: CGPoint {
		.init(x: size.width.half, y: size.height.half)
	}
}
