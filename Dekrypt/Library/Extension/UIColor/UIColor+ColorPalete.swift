//
//  UIColor.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/09/2022.
//

import Foundation
import UIKit

extension UIColor {
	enum Catalogue: String {
		case greyscale50
		case greyscale100
		case greyscale200
		case greyscale300
		case greyscale400
		case greyscale500
		case greyscale600
		case greyscale700
		case greyscale800
		case greyscale900
		case purple50
		case purple100
		case purple200
		case purple300
		case purple400
		case purple500
		case purple600
		case purple700
		case purple800
		case purple900
		case appBlue
		case appGreen
		case appRed
		case appOrange
        case appBlack
        case appWhite
		case surfaceBackground
		case surfaceBackgroundInverse
		case subtitleColor
		case textColor
        case textColorInverse
		case appIndigo
		case appIndigoFade
		case appIndigoFadeLight
		
		var color: UIColor {
			.init(named: self.rawValue) ?? .black
		}
	}
	
	static var greyscale50 : UIColor { Catalogue.greyscale50.color }
	static var greyscale100 : UIColor { Catalogue.greyscale100.color }
	static var greyscale200 : UIColor { Catalogue.greyscale200.color }
	static var greyscale300 : UIColor { Catalogue.greyscale300.color }
	static var greyscale400 : UIColor { Catalogue.greyscale400.color }
	static var greyscale500 : UIColor { Catalogue.greyscale500.color }
	static var greyscale600 : UIColor { Catalogue.greyscale600.color }
	static var greyscale700 : UIColor { Catalogue.greyscale700.color }
	static var greyscale800 : UIColor { Catalogue.greyscale800.color }
	static var greyscale900 : UIColor { Catalogue.greyscale900.color }
	static var purple50 : UIColor { Catalogue.purple50.color }
	static var purple100 : UIColor { Catalogue.purple100.color }
	static var purple200 : UIColor { Catalogue.purple200.color }
	static var purple300 : UIColor { Catalogue.purple300.color }
	static var purple400 : UIColor { Catalogue.purple400.color }
	static var purple500 : UIColor { Catalogue.purple500.color }
	static var purple600 : UIColor { Catalogue.purple600.color }
	static var purple700 : UIColor { Catalogue.purple700.color }
	static var purple800 : UIColor { Catalogue.purple800.color }
	static var purple900 : UIColor { Catalogue.purple900.color }
	static var appBlue : UIColor { Catalogue.appBlue.color }
	static var appGreen : UIColor { Catalogue.appGreen.color }
	static var appRed : UIColor { Catalogue.appRed.color }
	static var appOrange : UIColor { Catalogue.appOrange.color }
    static var appWhite : UIColor { Catalogue.appWhite.color }
    static var appBlack : UIColor { Catalogue.appBlack.color }
	static var surfaceBackground : UIColor { Catalogue.surfaceBackground.color }
	static var surfaceBackgroundInverse : UIColor { Catalogue.surfaceBackgroundInverse.color }
	static var subtitleColor : UIColor { Catalogue.subtitleColor.color }
	static var textColor : UIColor { Catalogue.textColor.color }
    static var textColorInverse: UIColor { Catalogue.textColorInverse.color }
	static var appIndigo : UIColor { Catalogue.appIndigo.color }
	static var appIndigoFade : UIColor { Catalogue.appIndigoFade.color }
	static var appIndigoFadeLight : UIColor { Catalogue.appIndigoFadeLight.color }
}
