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
    
    public var viewTransitioner: PresentDelegate?
    private var bag: Set<AnyCancellable> = .init()
    private var selectedEvent: PassthroughSubject<EventModel?, Never> = .init()
    var selectedMention: CurrentValueSubject<MentionModel?, Never> = .init(nil)
    private var selectedDestination: CurrentValueSubject<ViewMoreDestination?, Never> = .init(nil)
    
    struct Output {
        let sections: AnyPublisher<[TableSection], Error>
        let selectedMention: AnyPublisher<MentionModel, Never>
        let selectedEvent: AnyPublisher<EventModel, Never>
    }
    
    func transform() -> Output {
        let headlinesSection = fetchTrendingHeadlines()
        let mentionSection = fetchTopMentionedCoins()
        let eventSection = fetchEvents()
        let tweetSection = fetchTweets()
        
        
        let sections = Publishers.Zip4(headlinesSection, mentionSection, eventSection, tweetSection)
            .subscribe(on: RunLoop.main)
            .map { (headline, mention, event, tweet) in
                return [event, headline, mention, tweet]
            }
            .eraseToAnyPublisher()
        
        let selectedMention = selectedMention.compactMap { $0 }.eraseToAnyPublisher()
        
        let selectedEvent = selectedEvent.compactMap { $0 }.eraseToAnyPublisher()
        
        return .init(sections: sections, selectedMention: selectedMention, selectedEvent: selectedEvent)
    }
    
    private func fetchTrendingHeadlines() -> AnyPublisher<TableSection, Error> {
        StubTrendingHeadlines.shared.fetchHeadlines()
            .compactMap { $0.data }
            .compactMap { [weak self] in
                guard let self else { return nil }
                return .init(rows: $0.limitTo(to: 3).compactMap { TableRow<TrendingHeadlineCell>($0) },
                             title: "Trending Headlines")
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchTopMentionedCoins() -> AnyPublisher<TableSection, Error>{
        StubMentionService.shared.fetchMentions(period: .weekly)
            .compactMap { $0.data?.all }
            .compactMap {[weak self] mentions in
                guard let self else { return nil }
                let topMentionedCoinsCellModel: [MentionCellModel] = mentions.compactMap { mention in
                        .init(model: mention) {
                            print("(DEBUG) Clicked : ", mention)
                            self.selectedMention.send(mention)
                        }
                }
                return .init(rows: topMentionedCoinsCellModel.limitTo(to: 5).compactMap { TableRow<TopMentionCell>($0) },
                             title: "Top Mentioned Coins")
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
            .compactMap{ [weak self] tweets in
                guard let self else { return nil }
                let collectionCells = tweets.limitTo(to: 5).compactMap { CollectionItem<RecentTweetCard>(.init(model: $0)) }
                return TableSection(rows: [TableRow<CollectionTableCell>(.init(cells: collectionCells,
                                                                        size: .init(width: .totalWidth, height: 320),
                                                                        inset: .init(vertical: 0, horizontal: 10),
                                                                        cellSize: .init(width: 225, height: 300), interspacing: 8))],
                                    title: "Top Tweets")
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
                TableSection(rows: [TableRow<CustomCuratedEvents>(.init(events: $0, selectedEvent: self.selectedEvent))], title: "Events")
            }
            .eraseToAnyPublisher()
    }
}


//MARK: - ViewMoreFooter

enum ViewMoreDestination {
    case events, headlines, tweets, topMentions
}

class ViewMoreFooter: UIView {
    
    private let selectedDestination: CurrentValueSubject<ViewMoreDestination?, Never>
    private let destination: ViewMoreDestination
    
    init(selectedDestination: CurrentValueSubject<ViewMoreDestination?, Never> , destination: ViewMoreDestination) {
        self.selectedDestination = selectedDestination
        self.destination = destination
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let buttonBlob = "View More".styled(font: .regular, color: .textColorInverse, size: 12).generateLabel
            .blobify(backgroundColor: .surfaceBackgroundInverse, edgeInset: .init(vertical: 5, horizontal: 7.5), borderColor: .clear, borderWidth: 0, cornerRadius: 8)
            .buttonify { [weak self] in
                guard let self else { return }
                self.selectedDestination.send(self.destination)
            }
        
        let stack = UIStackView.HStack(subViews: [.spacer(), buttonBlob], spacing: 8)
        
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .init(by: 7.5))
        
    }
    
}
