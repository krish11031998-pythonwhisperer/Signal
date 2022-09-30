//
//  StringFonts.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 28/09/2022.
//

import Foundation
import UIKit

enum CustomFonts:String{
	case black = "Satoshi-Black"
	case bold = "Satoshi-Bold"
	case regular = "Satoshi-Regular"
	case medium = "Satoshi-Medium"
	case light = "Satoshi-Light"
	
	func fontBuilder(size: CGFloat) -> UIFont? {
		.init(name: self.rawValue, size: size)
	}
}

extension String {
	
	func heading1(color: UIColor = .textColor) -> RenderableText { styled(font: .black, color: color, size: 32) }
	func heading2(color: UIColor = .textColor) -> RenderableText { styled(font: .black, color: color, size: 24) }
	func heading3(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 22) }
	func heading4(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 18) }
	func heading5(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 14) }
	func heading6(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 12) }
	func body1Bold(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 16) }
	func body1Medium(color: UIColor = .textColor) -> RenderableText { styled(font: .medium, color: color, size: 16) }
	func body1Regular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 16) }
	func body2Medium(color: UIColor = .textColor) -> RenderableText { styled(font: .medium, color: color, size: 14) }
	func body2Regular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 14) }
	func body3Medium(color: UIColor = .textColor) -> RenderableText { styled(font: .medium, color: color, size: 12) }
	func body3Regular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 12) }
	func bodySmallRegular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 11) }
	func largeBodyRegular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 16) }
}
