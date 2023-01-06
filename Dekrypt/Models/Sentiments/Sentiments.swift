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

    func sentimentIndicatorText(_ count: Int? = nil) -> RenderableText {
        let blob = UIImage.solid(color: color, circleFrame: .init(squared: 12)).toText(fontHeight: CustomFonts.regular.fontBuilder(size: 11)?.capHeight ?? .zero)
        let text = (count != nil ? "\(rawValue) : \(count!)" : "\(rawValue)").bodySmallRegular()
        return blob.appending(" ").appending(text)
    }
    
    func sentimentIndicator(_ count: Int? = nil) -> UIView {
        sentimentIndicatorText(count).generateLabel
    }
	
}

struct SentimentModel: Codable {
    let neutral: Int?
    let positive: Int?
    let negative: Int?
    let sentimentScore: Float?
    
    enum CodingKeys: String, CodingKey {
        case neutral, positive, negative
        case sentimentScore = "sentiment_score"
    }
}

struct SentimentForTicker: Codable {
    let total: SentimentModel?
    let timeline: [String: SentimentModel]?
}
