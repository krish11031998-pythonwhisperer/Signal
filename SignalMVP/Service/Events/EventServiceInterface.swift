//
//  EventServiceInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation

protocol EventServiceInterface {
	
	func fetchEvents(query: [URLQueryItem], completion: @escaping (Result<EventResult,Error>) -> Void)
}
