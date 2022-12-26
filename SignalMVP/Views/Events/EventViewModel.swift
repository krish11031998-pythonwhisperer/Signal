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
    private var nextPageToken: String?
    private var allEvents: [EventCellModel]? = nil
    
    struct Input {
        let searchParam: CurrentValueSubject<String?, Never>
        let nextPage: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        let tableSection: AnyPublisher<TableSection, Error>
        let dismissSearch: AnyPublisher<Bool, Never>
    }
        
    func transform(input: Input) -> Output {
        
        let nextPage = input.nextPage
            .removeDuplicates()
            .filter { [weak self] in $0 && (self?.nextPageToken != nil) }
            .withLatestFrom(input.searchParam)
            .flatMap { [weak self] in EventService.shared.fetchEvents(tickers: $0.1, after: self?.nextPageToken) }
            .compactMap { $0.data }
            .compactMap { [weak self] in self?.setupSection($0, append: true)}
            .eraseToAnyPublisher()
        
        let searchResult = input.searchParam
            .flatMap { EventService.shared.fetchEvents(tickers: $0) }
            .compactMap { $0.data }
            .compactMap { [weak self] in self?.setupSection($0, append: false)}
            .eraseToAnyPublisher()
        
        let events = Publishers.Merge(nextPage, searchResult).eraseToAnyPublisher()
        
        let dismiss = input.searchParam
            .compactMap { $0 == nil }
            .eraseToAnyPublisher()
    
        return .init(tableSection: events, dismissSearch: dismiss)
    }
    
    private func getNextPageToken(_ events: [EventModel]) {
        guard let lastPage = events.last?.eventId else { return }
        
        if  lastPage != nextPageToken {
            nextPageToken = lastPage
        } else {
            nextPageToken = nil
        }
    }
    
    private func setupSection(_ events: [EventModel], append: Bool = false) -> TableSection {
        
        getNextPageToken(events)
        
        let eventModels = events.compactMap {event in
            EventCellModel(model: event) {
                self.selectedEvent.send(event)
            }
        }
        
        if !append || allEvents == nil {
            allEvents = eventModels
        } else if append {
            allEvents?.append(contentsOf: eventModels)
        }
        
        let rows = (allEvents ?? []).compactMap {
            TableRow<EventSingleCell>($0)
        }
        
        return .init(rows: rows)
    }
}
