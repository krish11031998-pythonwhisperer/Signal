//
//  Sentiments.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 27/09/2022.
//

import Foundation
import UIKit

enum Sentiment: String, Codable, CaseIterable {
	case positve = "Positive"
	case negative = "Negative"
	case neutral = "Neutral"
}

extension Sentiment {
	
	var color: UIColor {
		switch self {
		case .positve:
			return .appGreen
		case .negative:
			return .appRed
		case .neutral:
			return .appOrange
		}
	}
	
	func sentimentIndicator(_ appending: String? = nil) -> UIView {
		let view = SentimentTextLabel()
		view.configureIndicator(label: rawValue + (appending ?? ""), color: color)
		return view
	}
	
}
