//
//  StubEventsService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation


class StubEventService: EventServiceInterface {
	
	public static var shared: StubEventService = .init()
	
	func fetchEvents(before: String? = nil, after: String? = nil, limit: Int = 10, completion: @escaping (Result<EventResult, Error>) -> Void) {
		let result: Result<EventResult, Error> = Bundle.main.loadDataFromBundle(name: "signalEvents", extensionStr: "json")
		completion(result)
	}
	
}
