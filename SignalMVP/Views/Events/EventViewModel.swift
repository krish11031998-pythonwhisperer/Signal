//
//  EventViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine

class EventViewModel {
	
    private var bag: Set<AnyCancellable> = .init()
	
    var events: AnyPublisher<TableSection,Never> {
        EventService.shared
            .fetchEvents()
            .catch { err in
                print("(DEBUG) err: ", err)
                return StubEventService.shared.fetchEvents()
            }
            .catch { _ in
                Just(EventResult(data: []))
            }
            .compactMap { Set($0.data).compactMap{ model in EventCellModel(model: model, action: { EventStorage.selectedEvent = model } ) } }
            .map {
                TableSection(rows: $0.map { TableRow<EventSingleCell>($0)})
            }
            .eraseToAnyPublisher()
    }
}
