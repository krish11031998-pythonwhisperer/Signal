//
//  SignalTwitterService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/09/2022.
//

import Foundation
import Combine

enum TweetEndpoints {
    case tweets(entity: String?, page: Int, limit: Int = 20)
}


extension TweetEndpoints: EndPoint {
	var scheme: String {
		return "https"
	}
    
	var path: String {
		switch self {
		case .tweets:
			return "/twitter/tweets"
		}
	}
	
	var queryItems: [URLQueryItem] {
		switch self {
		case .tweets(let entity, let page, let limit):
			return [
				.init(name: "entity", value: entity),
				.init(name: "page", value: "\(page)"),
				.init(name: "limit", value: "\(limit)")
			].filter { $0.value != nil  }
		}
	}
	
    func fetch() -> Future<TweetSearchResult, Error> {
        guard let validRequest = request else {
            return Future { $0(.failure(URLSessionError.invalidUrl))}
        }
        return URLSession.urlSessionRequest(request: validRequest)
    }
	
}
