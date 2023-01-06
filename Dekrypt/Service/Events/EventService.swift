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
	
    public func fetchEventsForAllTickers(entity: [String]? = nil, page: Int = 0, limit: Int = 20, refresh: Bool) -> AnyPublisher<EventResult, Error> {
        EventEndpoints
            .eventsForAllTickers(entity: entity, page: page, limit: limit)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
    }
}
