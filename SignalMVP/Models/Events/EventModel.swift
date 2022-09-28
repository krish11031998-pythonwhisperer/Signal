//
//  EventModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation


struct EventResult: Codable {
	let data: [String: EventModel]
}

struct EventModel: Codable {
	
	let date: String
	let eventId: String
	let eventName: String
	let news: [NewsModel]
	let tickers: [String]
	
	enum CodingKeys: String, CodingKey {
		case date, news
		case eventId = "event_id"
		case eventName = "event_name"
		case tickers
		
	}
}

extension EventModel: Equatable {
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.eventId == rhs.eventId
	}
}


extension EventModel: Hashable {
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(eventId)
	}
}