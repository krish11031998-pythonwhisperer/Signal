//
//  EventStorage.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 26/09/2022.
//

import Foundation
import UIKit
class EventStorage {
	
	public static var selectedEvent: EventModel? = nil {
		didSet {
			if selectedEvent != nil {
				NotificationCenter.default.post(name: .showEvent, object: nil)
			}
		}
	}
}