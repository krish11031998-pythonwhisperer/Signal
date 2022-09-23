//
//  NewsModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

struct NewsFirebaseResult: Codable {
	let data: [String: NewsModel]?
}

struct NewsModel: Codable {
//	let createdAt: String
	let date: String
	let imageUrl: String
	let newsUrl: String
	let sentiment: String
	let sourceName: String
	let text: String
	let tickers: [String]
	let title: String
	
	enum CodingKeys: String, CodingKey {
//		case createdAt
		case date
		case imageUrl = "image_url"
		case newsUrl = "news_url"
		case sentiment
		case sourceName = "source_name"
		case text
		case tickers
		case title
	}
}
