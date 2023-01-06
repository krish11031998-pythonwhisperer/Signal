//
//  SignalTwitterService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/09/2022.
//

import Foundation
import Combine

enum TweetEndpoints {
    case tweetsForAllTickers(entity: String?, page: Int, limit: Int = 20)
    case tweetsForTicker(ticker: String, limit: Int = 20, nextPageToken: String?)
}


extension TweetEndpoints: EndPoint {
    
	var scheme: String {
		return "https"
	}
    
	var path: String {
		switch self {
		case .tweetsForAllTickers:
			return "/twitter/tweets"
        case .tweetsForTicker:
            return "/tickers/tweets"
		}
	}
	
	var queryItems: [URLQueryItem] {
		switch self {
		case .tweetsForAllTickers(let entity, let page, let limit):
			return [
				.init(name: "entity", value: entity),
				.init(name: "page", value: "\(page)"),
				.init(name: "limit", value: "\(limit)")
			].filter { $0.value != nil  }
        case .tweetsForTicker(let ticker, let limit, let nextPageToken):
            return [
                .init(name: "ticker", value: ticker),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "token", value: nextPageToken)
            ].filter { $0.value != nil  }
		}
	}
	
}
