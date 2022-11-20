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
			return .appIndigo
		}
	}

    func sentimentIndicator(_ count: Int? = nil) -> UIView {
        let blob = UIImage.solid(color: color, circleFrame: .init(squared: 12)).toText(fontHeight: CustomFonts.regular.fontBuilder(size: 11)?.capHeight ?? .zero)
        let text = count != nil ? "Neutral : \(count!)".bodySmallRegular() : "Neutral"
        return blob.appending(" ").appending(text).generateLabel
    }
	
}
