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

//        Publishers.Zip3($events, $trendingHeadlines, $mentions)
//            .sink { [weak self] (events, tweets, trendingHeadlines) in
//                guard let `self` = self else { return }
//                self.view?.reloadTableWithDataSource(.init(sections: [self.storiesSection,
//                                                                      self.headerSection,
//                                                                      self.trendingHeadlinesSection,
//                                                                      self.topMentionedCoinsSection].compactMap { $0 }))
//            }
//            .store(in: &bag)
//        fetchTweets()
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//            switch completion {
//            case .failure(let err):
//                print("(DEBUG) err", err)
//            default: break
//            }
//        } receiveValue: {[weak self] section in
//            guard let `self` = self else { return }
//            self.view?.reloadTableWithDataSource(.init(sections: [section]))
//        }
//        .store(in: &bag)

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
            .catch{ _ in
                StubTweetService.shared.fetchTweets()
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
            .catch { _ in
                StubEventService.shared.fetchEvents()
            }
            .compactMap { $0.data }
            .map {
                TableSection(rows: [TableRow<CustomCuratedEvents>($0)], title: "Events")
            }
            .eraseToAnyPublisher()
    }
    
////MARK: - Sections
//    private var trendingHeadlinesSection: TableSection? {
//        guard let validTrendingHeadlines = trendingHeadlines else { return nil }
//        return .init(rows: validTrendingHeadlines.limitTo(to: 3).compactMap { TableRow<TrendingHeadlineCell>($0) }, title: "Trending Headlines")
//    }
//
//
//    private var topMentionedCoinsSection: TableSection? {
//        guard let validTopMentionedCoins = mentions else { return nil }
//        let topMentionedCoinsCellModel: [MentionCellModel] = validTopMentionedCoins.compactMap { mention in
//                .init(model: mention) {
//                    print("(DEBUG) Clicked : ", mention)
//                    MentionStorage.selectedMention = mention
//                    NotificationCenter.default.post(name: .showMention, object: nil)
//                }
//        }
//        return .init(rows: topMentionedCoinsCellModel.limitTo(to: 5).compactMap { TableRow<TopMentionCell>($0) }, title: "Top Mentioned Coins")
//    }
//
//    private var videoSection: TableSection? {
//        guard let videoSection = videos else { return nil }
//        return .init(rows: videoSection.limitTo(to: 3).compactMap { TableRow<VideoCell>($0) }, title: "Top Video News")
//    }
//
//    private var tweetsSection: TableSection? {
//        guard let tweetsSection = tweets else { return nil }
//        let collectionCells = tweetsSection.limitTo(to: 5).compactMap { CollectionItem<RecentTweetCard>(.init(model: $0)) }
//        return .init(rows: [TableRow<CollectionTableCell>(.init(cells: collectionCells,
//                                                                size: .init(width: .totalWidth, height: 320),
//                                                                inset: .init(vertical: 0, horizontal: 10),
//                                                                cellSize: .init(width: 225, height: 300), interspacing: 8))], title: "Top Tweets" )
//    }
//
//    private var storiesSection: TableSection? {
//        guard let validMention = mentions else { return nil }
//        let collectionCells = validMention.map { mention in
//            let model: MentionCellModel = .init(model: mention, action: nil) { frame in
//                self.handleTap(origin: frame, model: mention)
//            }
//            return CollectionItem<TopMentionStoryCell>(model)
//        }
//        return .init(rows: [TableRow<CollectionTableCell>(.init(cells: collectionCells, inset: .init(vertical: 0, horizontal: 10), cellSize: .init(squared: 64)))])
//
//    }
//
//    private func handleTap(origin: CGRect, model: MentionModel) {
//        MentionStorage.selectedMention = model
//        TopMentionStoryCell.visitedCells.insert(model)
//        viewTransitioner?.presentView(origin: origin)
//    }
//
//    private var headerSection: TableSection? {
//        guard let validEvents = events else { return nil }
//        return .init(rows: [TableRow<CustomCuratedEvents>(validEvents)], title: "Events")
//    }
//
//    private func buildDataSource() -> TableViewDataSource{
//        .init(sections: [storiesSection, headerSection, trendingHeadlinesSection, topMentionedCoinsSection].compactMap { $0 })//, tweetsSection].compactMap { $0 })
//    }
}
