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
    private var selectedNavigation: PassthroughSubject<Navigation, Never> = .init()
    private let authPublisher: AuthPublisher = .init()
    
    enum Navigation {
        case toEvent(_ model: EventModel)
        case toNews(_ model: NewsModel)
        case toTweet(_ model: TweetModel)
        case toMention(_ model: MentionModel)
        case viewMoreEvent, viewMoreNews, viewMoreTweet
    }
    
    struct Output {
        let sections: AnyPublisher<[TableSection], Error>
        let navigation: AnyPublisher<Navigation, Never>
        let user: AnyPublisher<UserModel, Error>
    }
    
    func transform() -> Output {
        let sections = fetchSections()
        
        selectedEvent
            .sink { [weak self] in
                guard let self, let validEvent = $0 else { return }
                self.selectedNavigation.send(.toEvent(validEvent))
            }
            .store(in: &bag)
        
        let selectedNavigation = selectedNavigation.eraseToAnyPublisher()
        
        let showProfile = authPublisher
            .compactMap { $0?.uid }
            .flatMap {
                UserService.shared.getUser(userId: $0)
            }
            .compactMap { $0.data }
            .eraseToAnyPublisher()
        
        return .init(sections: sections,
                     navigation: selectedNavigation,
                     user: showProfile)
    }
    
    private func fetchSections() -> AnyPublisher<[TableSection], Error> {
        SocialHighlightService
            .shared
            .fetchSocialHighlight()
            .compactMap { [weak self] in
                guard let self, let data = $0.data else { return nil }
                return self.buildSection(data)
            }
            .eraseToAnyPublisher()
        
    }
    
    private func buildSection(_ socialData: SocialHighlightModel) -> [TableSection] {
        var section: [TableSection] = []
        
        if let events = socialData.events {
            let footer = [TableRow<ViewMoreFooter>(.init(destination: .viewMoreEvent,
                                                         selectedViewMoreNavigation: self.selectedNavigation))]
            let eventSection = TableSection(rows: [TableRow<CustomCuratedEvents>(.init(events: events, selectedEvent: self.selectedEvent))] + footer, title: "Events")
            
            section.append(eventSection)
        }

        if let news = socialData.news?.limitTo(to: 5) {
            let newsRow = news.compactMap { news in
                TableRow<NewsCell>(.init(model: news, action: {
                    self.selectedNavigation.send(.toNews(news))
                }))
            }
            let footer = [TableRow<ViewMoreFooter>(.init(destination: .viewMoreNews,
                                                         selectedViewMoreNavigation: self.selectedNavigation))]
            section.append(.init(rows: newsRow + footer,
                                 title: "News"))
        }

        if let tweets = socialData.tweets {
            let collectionCells = tweets.limitTo(to: 5).compactMap { tweet in
                CollectionItem<RecentTweetCard>(.init(model: tweet, action: {
                    self.selectedNavigation.send(.toTweet(tweet))
                }))
            }
            let footer = [TableRow<ViewMoreFooter>(.init(destination: .viewMoreTweet,
                                                           selectedViewMoreNavigation: self.selectedNavigation))]
            let tweetSection = TableSection(rows: [TableRow<CollectionTableCell>(.init(cells: collectionCells,
                                                                                       size: .init(width: .totalWidth, height: 300),
                                                                                       inset: .init(vertical: 0, horizontal: 10),
                                                                                       cellSize: .init(width: 225, height: 275),
                                                                                       interspacing: 8))] + footer,
                                            title: "Top Tweets")
            section.append(tweetSection)
        }
        
        return section
    }
    
}


//MARK: - ViewMoreFooter

struct ViewMoreFooterModel {
    let destination: HomeViewModel.Navigation
    let selectedViewMoreNavigation: PassthroughSubject<HomeViewModel.Navigation, Never>
}

class ViewMoreFooter: ConfigurableCell {
    
    private let selectedDestination: PassthroughSubject<(), Never> = .init()
    private var cancellable: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let buttonBlob = "View More".styled(font: .regular, color: .textColorInverse, size: 12).generateLabel
            .blobify(backgroundColor: .surfaceBackgroundInverse, edgeInset: .init(vertical: 10, horizontal: 12.5), borderColor: .clear, borderWidth: 0, cornerRadius: 12)
            .buttonify { [weak self] in
                guard let self else { return }
                self.selectedDestination.send(())
            }
        
        let height = buttonBlob.compressedSize.height
        buttonBlob.cornerRadius = height.half
        
        let stack = UIStackView.HStack(subViews: [.spacer(), buttonBlob], spacing: 8)
        
        backgroundColor = .surfaceBackground
        selectionStyle = .none
        contentView.addSubview(stack)
        contentView.setFittingConstraints(childView: stack, insets: .init(vertical: 0, horizontal: 10))
        
    }
    
    override func prepareForReuse() {
        cancellable?.cancel()
    }
    
    func configure(with model: ViewMoreFooterModel) {
        cancellable = selectedDestination
            .sink { _ in
                model.selectedViewMoreNavigation.send(model.destination)
            }
    }
    
}

