//
//  SignalEventService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/09/2022.
//

import Foundation
import Combine

enum SignalEventEndpoints {
    case latestEvents(tickers: String?, before: String?, after: String?, limit: Int)
}

extension SignalEventEndpoints: EndPoint {
	var scheme: String {
		return "https"
	}
	
	var path: String {
		switch self {
		case .latestEvents:
			return "/events/latestEvents"
		}
	}
	
	var queryItems: [URLQueryItem] {
		switch self {
		case .latestEvents(let tickers, let before, let after, let limit):
			return [
                .init(name: "tickers", value: tickers),
				.init(name: "before", value: before),
				.init(name: "after", value: after),
				.init(name: "limit", value: "\(limit)")
			].filter { $0.value != nil }
		}
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
	
    public func fetchEvents(tickers: String? = nil, before: String? = nil, after: String? = nil, limit: Int = 20) -> AnyPublisher<EventResult, Error> {
        SignalEventEndpoints
            .latestEvents(tickers: tickers, before: before, after: after, limit: limit)
            .fetch()
            .eraseToAnyPublisher()
    }
	
}
