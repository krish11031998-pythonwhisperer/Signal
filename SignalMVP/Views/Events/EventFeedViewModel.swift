//
//  EventViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine

class EventFeedViewModel {
	
    private var bag: Set<AnyCancellable> = .init()
    var selectedEvent: PassthroughSubject<EventModel?, Never> = .init()
    private var nextPageToken: Int = 0
    private var allEvents: [EventCellModel]? = nil
    
    struct Input {
        let searchParam: SharePublisher<String?, Never> //Publishers.Share<AnyPublisher<String?, Never>>
        let nextPage: Publishers.Share<AnyPublisher<Bool, Never>>
    }
    
    struct Output {
        let tableSection: AnyPublisher<TableSection, Error>
        let dismissSearch: AnyPublisher<Bool, Never>
        let loading: AnyPublisher<Bool, Never>
    }
        
    func transform(input: Input) -> Output {
        
        let nextPage = input.nextPage
            .removeDuplicates()
            .filter { [weak self] in $0 && (self?.nextPageToken != nil) }
            .withLatestFrom(input.searchParam)
            .flatMap { [weak self] in EventService.shared.fetchEvents(entity: [$0.1].compactMap { $0 }, page: self?.nextPageToken ?? 0) }
            .compactMap { $0.data }
            .compactMap { [weak self] in self?.setupSection($0, append: true)}
            .eraseToAnyPublisher()
        
        let searchResult = input.searchParam
            .flatMap { EventService.shared.fetchEvents(entity: [$0].compactMap { $0 }) }
            .compactMap { $0.data }
            .compactMap { [weak self] in self?.setupSection($0, append: false)}
            .eraseToAnyPublisher()
        
        let loading = input.nextPage
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let events = Publishers.Merge(nextPage, searchResult).eraseToAnyPublisher()
        
        let dismiss = input.searchParam
            .compactMap { $0 == nil }
            .eraseToAnyPublisher()
    
        return .init(tableSection: events, dismissSearch: dismiss, loading: loading)
    }
    
    private func getNextPageToken(_ events: [EventModel]) {
        guard events.count > 0 else { return }
        nextPageToken += 1
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