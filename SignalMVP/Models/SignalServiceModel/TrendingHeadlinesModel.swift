//
//  TrendingHeadlinesModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit
struct TrendingHeadlinesResult: Codable {
	let data: [TrendingHeadlinesModel]?
}

struct TrendingHeadlinesModel: Codable {
	let id: Int
	let headline: String
	let text: String
	let newsId: Int
	let sentiment: Sentiment
	let date: String
	let tickers: [String]
	
	enum CodingKeys: String, CodingKey {
		case id, headline, text
		case newsId = "news_id"
		case sentiment, date, tickers
	}
}

extension TrendingHeadlinesModel {
    
    var sentimentBlob: UIImage {
        UIImage.solid(color: sentiment.color, circleFrame: .init(squared: 10))
    }
    
}
//extension TrendingHeadlinesModel {
//	
//	var sentimentColor: UIColor {
//		sentiment == "Positive" ? .green : sentiment == "Neutral" ? .gray : .red
//	}
//	
//	var sentimentBlob: UIView {
//		let label: UILabel = sentiment.styled(font: .systemFont(ofSize: 12, weight: .medium), color: sentimentColor)
//			.generateLabel
//		return label.blobify(backgroundColor: sentimentColor.withAlphaComponent(0.15),
//							 borderColor: sentimentColor,
//							 borderWidth: 1,
//							 cornerRadius: 10)
//	}
//}
