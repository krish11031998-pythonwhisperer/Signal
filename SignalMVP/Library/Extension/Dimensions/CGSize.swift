//
//  CGSize.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 20/09/2022.
//

import Foundation
import UIKit

extension CGSize {
	
	static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
		.init(width: lhs.width * rhs, height: lhs.height * rhs)
	}
	
	var half: CGSize { .init(width: width * 0.5, height: height * 0.5) }
	
	init(squared: CGFloat) {
		self.init(width: squared, height: squared)
	}
	
	var frame: CGRect { .init(origin: .zero, size: self) }
	
	static var smallestSquare: CGSize  { .init(squared: 32) }
	
}
