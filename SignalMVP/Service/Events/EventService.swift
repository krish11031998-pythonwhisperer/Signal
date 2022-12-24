//
//  SignalEventService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/09/2022.
//

import Foundation
import Combine

class EventService: EventServiceInterface {
	
	public static var shared: EventService = .init()
	
    public func fetchEvents(tickers: String? = nil, before: String? = nil, after: String? = nil, limit: Int = 20) -> AnyPublisher<EventResult, Error> {
        EventEndpoints
            .latestEvents(tickers: tickers, before: before, after: after, limit: limit)
            .execute()
            .eraseToAnyPublisher()
    }
	
}
