//
//  EventServiceInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine

protocol EventServiceInterface {
	
    func fetchEvents(tickers: String?, before: String?, after: String?, limit: Int) -> AnyPublisher<EventResult,Error>
}
