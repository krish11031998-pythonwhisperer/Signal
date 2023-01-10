//
//  NewsModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

struct NewsResult: Codable {
	let data: [NewsModel]?
}

struct NewsModel: Tickers, Codable  {

    let newsId: Int?
	let date: String
	let imageUrl: String
	let newsUrl: String
	let sentiment: Sentiment
	let sourceName: String
	let text: String
	let title: String
	let type: String
    var tickers: [String]?
    
	enum CodingKeys: String, CodingKey {
		case date
		case imageUrl = "image_url"
		case newsUrl = "news_url"
		case sentiment
		case sourceName = "source_name"
		case text
		case tickers
		case title
		case type
        case newsId = "news_id"
	}
}
