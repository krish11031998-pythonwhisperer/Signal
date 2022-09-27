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
		["Authorization" : "Bearer AAAAAAAAAAAAAAAAAAAAAJHAagEAAAAAmFRvYKE8KtF%2BTvVxYsse0GC6faE%3DsuQdyHCBqKvhOjmoGGfUPNOCG41QZySz1BQWgJB5i0QIN7wbaE"]
	}
	
	func fetch(completion: @escaping (Result<TweetSearchResult, Error>) -> Void) {
		guard let validRequest = request else {
			completion(.failure(URLSessionError.invalidUrl))
			return
		}
		
		URLSession.urlSessionRequest(request: validRequest, completion: completion)
	}

	
}
