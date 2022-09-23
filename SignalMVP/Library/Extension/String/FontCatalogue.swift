//
//  FontCatalogue.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 19/09/2022.
//

import Foundation
import UIKit

extension UIFont {
	
	enum Catalogue: String {
		case codeProBold = "Code Pro Bold LC"
		case codePro = "Code Pro LC"
		case montserratLightItalic = "Montserrat-LightItalic"
		case montserratMedium = "Montserrat-Medium"
		case montserratBoldItalic = "Montserrat-BoldItalic"
		case montserratBold = "Montserrat-Bold"
		case montserratMediumItalic = "Montserrat-MediumItalic"
		case montserratSemiBold = "Montserrat-SemiBold"
		case montserratSemiBoldItalic = "Montserrat-SemiBoldItalic"
	}
	
	static func heading() -> UIFont { Catalogue.montserratBold.font(size: 30)  }
	static func body() -> UIFont { Catalogue.montserratMedium.font(size: 15) }
}

extension UIFont.Catalogue {
	
	func font(size: CGFloat) -> UIFont { .init(name: rawValue, size: size) ?? .init() }
}
