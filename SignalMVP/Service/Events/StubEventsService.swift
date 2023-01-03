//
//  StubEventsService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine

class StubEventService: EventServiceInterface {
	
	public static var shared: StubEventService = .init()
	
    func fetchEvents(entity: [String]? = nil, page: Int = 0, limit: Int = 10, refresh: Bool = false) -> AnyPublisher<EventResult, Error> {
        Bundle.main.loadDataFromBundle(name: "signalEvents", extensionStr: "json")
    }
	
}
