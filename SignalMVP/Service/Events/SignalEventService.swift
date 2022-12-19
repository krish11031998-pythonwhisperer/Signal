//
//  SignalEventService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/09/2022.
//

import Foundation
import Combine

enum SignalEventEndpoints {
	case latestEvents(before: String?, after: String?, limit: Int)
}

extension SignalEventEndpoints: EndPoint {
	var scheme: String {
		return "https"
	}
	
	var baseUrl: String {
		"crybseserver-production.up.railway.app"
	}
	
	var path: String {
		switch self {
		case .latestEvents(_, _, _):
			return "/events/latestEvents"
		}
	}
	
	var queryItems: [URLQueryItem] {
		switch self {
		case .latestEvents(let before, let after, let limit):
			return [
				.init(name: "before", value: before),
				.init(name: "after", value: after),
				.init(name: "limit", value: "\(limit)")
			].filter { $0.value != nil }
		}
	}
	
	func fetch(completion: @escaping (Result<EventResult, Error>) -> Void) {
		guard let validRequest = request else {
			completion(.failure(URLSessionError.invalidUrl))
			return
		}
		URLSession.urlSessionRequest(request: validRequest, completion: completion)
	}
	
    func fetch() -> Future<EventResult, Error> {
        guard let validRequest = request else {
            return Future { $0(.failure(URLSessionError.invalidUrl))}
        }
        return URLSession.urlSessionRequest(request: validRequest)
    }
	
}


class EventService: EventServiceInterface {
	
	public static var shared: EventService = .init()
	
    public func fetchEvents(before: String? = nil, after: String? = nil, limit: Int = 20) -> Future<EventResult, Error> {
        SignalEventEndpoints
            .latestEvents(before: before, after: after, limit: limit)
            .fetch()
    }
	
}
