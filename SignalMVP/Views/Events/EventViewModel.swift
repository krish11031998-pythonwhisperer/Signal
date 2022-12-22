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
    var selectedEvent: PassthroughSubject<EventModel?, Never> = .init()
    
    struct Input {
        let searchParam: CurrentValueSubject<String?, Never>
    }
    
    struct Output {
        let tableSection: AnyPublisher<TableSection, Error>
        let dismissSearch: AnyPublisher<Bool, Never>
    }
    
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
            .compactMap { Set($0.data).compactMap{ model in EventCellModel(model: model, action: { self.selectedEvent.send(model) } ) } }
            .map {
                TableSection(rows: $0.map { TableRow<EventSingleCell>($0)})
            }
            .eraseToAnyPublisher()
    }
    
    func transform(input: Input) -> Output {
        let section = input.searchParam
            .flatMap { EventService.shared.fetchEvents(tickers: $0) }
            .catch {
                print("(DEBUG) err: ", $0)
                return StubEventService.shared.fetchEvents()
            }
            .compactMap { Set($0.data).compactMap{ model in EventCellModel(model: model, action: { self.selectedEvent.send(model) } ) } }
            .map {
                TableSection(rows: $0.map { TableRow<EventSingleCell>($0)})
            }
            .eraseToAnyPublisher()
        
        let dismiss = input.searchParam
            .compactMap { $0 == nil }
            .eraseToAnyPublisher()
    
        return .init(tableSection: section, dismissSearch: dismiss)
    }
}
