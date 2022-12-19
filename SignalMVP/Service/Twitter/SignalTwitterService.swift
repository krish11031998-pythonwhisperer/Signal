//
//  SignalTwitterService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/09/2022.
//

import Foundation
import Combine

enum SignalTwitterEndpoints {
	case tweets(entity: String?, before: String?, after: String?, limit: Int = 20)
}


extension SignalTwitterEndpoints: EndPoint {
	var scheme: String {
		return "https"
	}
	
	var baseUrl: String {
		"crybseserver-production.up.railway.app"
	}
	
	var path: String {
		switch self {
		case .tweets(_,_,_,_):
			return "/twitter/tweets"
		}
	}
	
	var queryItems: [URLQueryItem] {
		switch self {
		case .tweets(let entity, let before, let after, let limit):
			return [
				.init(name: "entity", value: entity),
				.init(name: "before", value: before),
				.init(name: "after", value: after),
				.init(name: "limit", value: "\(limit)")
			].filter { $0.value != nil  }
		}
	}
	
	func fetch(completion: @escaping (Result<TweetSearchResult, Error>) -> Void) {
		guard let validRequest = request else {
			completion(.failure(URLSessionError.invalidUrl))
			return
		}
		URLSession.urlSessionRequest(request: validRequest, completion: completion)
	}
	
    func fetch() -> Future<TweetSearchResult, Error> {
        guard let validRequest = request else {
            return Future { $0(.failure(URLSessionError.invalidUrl))}
        }
        return URLSession.urlSessionRequest(request: validRequest)
    }
	
}
