//
//  EventServiceInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine

protocol EventServiceInterface {
	
    func fetchEvents(before: String?, after: String?, limit: Int) -> Future<EventResult,Error>
}
