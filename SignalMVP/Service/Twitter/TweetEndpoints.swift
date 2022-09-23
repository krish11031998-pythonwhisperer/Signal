//
//  TweetEndpoints.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation

enum TweetEndpoint {
	case searchRecent(queries: [URLQueryItem])
}

extension TweetEndpoint: EndPoint {
		
	typealias CodableModel = TweetSearchResult
	
	var scheme: String {
		"https"
	}
	
	var baseUrl: String {
		"api.twitter.com"
	}
	
	var path: String {
		switch self {
		case .searchRecent(_) :
			return "/2/tweets/search/recent"
		}
	}
	
	var queryItems: [URLQueryItem] {
		switch self {
		case .searchRecent(let queries):
			return queries
		}
	}
	
	var header: [String : String]? {
		["Authorization" : "Bearer AAAAAAAAAAAAAAAAAAAAAJHAagEAAAAApX73ZCZyNl5HkLYcBoQ5LRM2bI0%3DoC55DQsTmFjR5guDHN6lBTlytyQ1bEJIRuEeAD3NoJapA9y0BG"]
	}
	
	func fetch(completion: @escaping (Result<TweetSearchResult, Error>) -> Void) {
		guard let validRequest = request else {
			completion(.failure(URLSessionError.invalidUrl))
			return
		}
		
		URLSession.urlSessionRequest(request: validRequest, completion: completion)
	}

	
}
