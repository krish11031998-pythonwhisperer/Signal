//
//  HomeViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit
import Combine

protocol PresentDelegate {
    func presentView(origin: CGRect)
}
 
class HomeViewModel {
    
    @Published private var trendingHeadlines: [TrendingHeadlinesModel]?
    @Published private var mentions: [MentionModel]?
    @Published private var videos: [VideoModel]?
    @Published private var tweets: [TweetModel]?
    @Published private var events: [EventModel]?
    
    public var view: AnyTableView?
    public var viewTransitioner: PresentDelegate?
    private var bag: Set<AnyCancellable> = .init()
    public func fetchHomePageData() {
        let headlinesSection = fetchTrendingHeadlines()
        let mentionSection = fetchTopMentionedCoins()
        let eventSection = fetchEvents()
        let tweetSection = fetchTweets()
        Publishers.Zip4(headlinesSection, mentionSection, eventSection, tweetSection)
            .receive(on: DispatchQueue.main)
            .sink { _ in

            } receiveValue: { [weak self] (headlines, mentions, event, tweetSection) in
                guard let `self` = self else { return }
                self.view?.reloadTableWithDataSource(.init(sections: [event, headlines, mentions, tweetSection]))
            }
            .store(in: &bag)
    }
    
    private func fetchTrendingHeadlines() -> AnyPublisher<TableSection, Error> {
        StubTrendingHeadlines.shared.fetchHeadlines()
            .compactMap { $0.data }
            .map {
                return .init(rows: $0.limitTo(to: 3).compactMap { TableRow<TrendingHeadlineCell>($0) }, title: "Trending Headlines")
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchTopMentionedCoins() -> AnyPublisher<TableSection, Error>{
        StubMentionService.shared.fetchMentions(period: .weekly)
            .compactMap { $0.data?.all }
            .map { mentions in
                let topMentionedCoinsCellModel: [MentionCellModel] = mentions.compactMap { mention in
                        .init(model: mention) {
                            print("(DEBUG) Clicked : ", mention)
                            MentionStorage.selectedMention = mention
                            NotificationCenter.default.post(name: .showMention, object: nil)
                        }
                }
                return .init(rows: topMentionedCoinsCellModel.limitTo(to: 5).compactMap { TableRow<TopMentionCell>($0) }, title: "Top Mentioned Coins")
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchTweets() -> AnyPublisher<TableSection,Error> {
        TweetService.shared.fetchTweets()
            .catch{
                print("(ERROR) Tweets err: ", $0.localizedDescription)
                return StubTweetService.shared.fetchTweets()
            }
            .compactMap { $0.data }
            .map{ tweets in
                let collectionCells = tweets.limitTo(to: 5).compactMap { CollectionItem<RecentTweetCard>(.init(model: $0)) }
                return TableSection(rows: [TableRow<CollectionTableCell>(.init(cells: collectionCells,
                                                                        size: .init(width: .totalWidth, height: 320),
                                                                        inset: .init(vertical: 0, horizontal: 10),
                                                                        cellSize: .init(width: 225, height: 300), interspacing: 8))], title: "Top Tweets" )
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchEvents() -> AnyPublisher<TableSection,Error> {
        EventService.shared.fetchEvents()
            .catch {
                print("(ERROR) EventFetch err:", $0.localizedDescription)
                return StubEventService.shared.fetchEvents()
            }
            .compactMap { $0.data }
            .map {
                TableSection(rows: [TableRow<CustomCuratedEvents>($0)], title: "Events")
            }
            .eraseToAnyPublisher()
    }
}
