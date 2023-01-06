//
//  EventDetailViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/01/2023.
//

import Foundation
import UIKit
import Combine

class EventDetailViewModel {
    
    private let eventModel: EventModel?
    private let newsArticles: CurrentValueSubject<[NewsModel]?,Never>
    private let selectedNews: PassthroughSubject<NewsModel?, Never>
    private var bag: Set<AnyCancellable> = .init()
    
    var needToLoadNews: Bool { eventModel?.news?.isEmpty ?? true }
    
    init(eventModel: EventModel?) {
        self.eventModel = eventModel
        self.newsArticles = .init(eventModel?.news)
        self.selectedNews = .init()
    }
    
    struct Output {
        let section: AnyPublisher<[TableSection], Never>
        let selectedNews: AnyPublisher<NewsModel?, Never>
    }
    
    //MARK: - Exposed Methods
    func transform() -> Output {
        let section: AnyPublisher<[TableSection], Never> = newsArticles
            .compactMap { $0 }
            .map { [weak self] in
                guard let self else { return [] }
                let headerSection = self.headerSection(news: $0)
                let newsSection = self.remainingSection(news: $0)
                let headerView = self.headerView()
                return [headerView, headerSection, newsSection].compactMap { $0 }
            }
            .eraseToAnyPublisher()
        return .init(section: section, selectedNews: selectedNews.eraseToAnyPublisher())
    }
    
    func loadNewsForEvent() {
        guard let id = eventModel?.eventId else { return }
        NewsService
            .shared
            .fetchNewsForEvent(eventId: id, refresh: false)
            .compactMap { $0.data }
            .sink {
                if let err = $0.err?.localizedDescription {
                    print("(ERROR) err: ", err)
                }
            } receiveValue: { [weak self] news in
                self?.newsArticles.send(news)
            }
            .store(in: &bag)

    }
    
    //MARK: - Protected Methods
    
    private func headerView() -> TableSection? {
        guard let validEvent = eventModel else { return nil }
        return .init(rows: [TableRow<EventDetailViewHeader>(validEvent)])
    }
    
    private func headerSection(news: [NewsModel]) -> TableSection? {
        guard let validEvent = eventModel else { return nil }
        let mainEvent = EventModel(date: validEvent.date, eventId: validEvent.eventId, eventName: validEvent.eventName, news: news.limitTo(to: 3), newsItem: 3, tickers: [])
        let model = EventNewsModel(model: mainEvent, selectedNews: selectedNews)
        return .init(rows: [TableRow<EventCell>(model)])
    }
    
    private func remainingSection(news: [NewsModel]) -> TableSection? {
        guard news.count > 3 else { return nil }
        let newsCells = (news[3...]).compactMap { news in
            let model: NewsCellModel = .init(model: news) {
                self.selectedNews.send(news)
            }
            return TableRow<NewsCell>(model)
        }
        return .init(rows: newsCells)
    }
}
