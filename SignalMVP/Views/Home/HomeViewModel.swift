//
//  HomeViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit
import Combine

enum UserError: String, Error {
    case nilOrinvalidUID
}

protocol PresentDelegate {
    func presentView(origin: CGRect)
}
 
class HomeViewModel {
    
    @Published private var trendingHeadlines: [TrendingHeadlinesModel]?
    @Published private var mentions: [MentionTickerModel]?
    @Published private var videos: [VideoModel]?
    @Published private var tweets: [TweetModel]?
    @Published private var events: [EventModel]?
    
    private var bag: Set<AnyCancellable> = .init()
    private var selectedEvent: PassthroughSubject<EventModel?, Never> = .init()
    private var selectedNavigation: PassthroughSubject<Navigation, Never> = .init()
    private let authPublisher: AuthPublisher = .init()
    
    enum Navigation {
        case toEvent(_ model: EventModel)
        case toNews(_ model: NewsModel)
        case toTweet(_ model: TweetModel)
        case toMention(_ model: MentionTickerModel)
        case toTickerStory(_ model: MentionTickerModel, frame: CGRect)
        case toTickerDetail(_ model: MentionTickerModel)
        case viewMoreEvent, viewMoreNews, viewMoreTweet, viewMoreTrendingTickers(tickers: [MentionTickerModel])
    }
    
    struct Output {
        let sections: AnyPublisher<[TableSection], Error>
        let navigation: AnyPublisher<Navigation, Never>
        let user: AnyPublisher<UserModel?, Error>
    }
    
    func transform() -> Output {
        
        let user = authPublisher
            .map { $0?.uid }
            .flatMap {
                if let uid = $0 {
                    return UserService.shared.getUser(userId: uid)
                } else {
                    return Just(UserModelResponse(data: nil, err: nil, success: true))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
            .share()
        
        let sections = fetchSections(user: user)
        
        selectedEvent
            .sink { [weak self] in
                guard let self, let validEvent = $0 else { return }
                self.selectedNavigation.send(.toEvent(validEvent))
            }
            .store(in: &bag)
        
        let selectedNavigation = selectedNavigation.eraseToAnyPublisher()
        
        let showProfile = user
            .map { $0.data }
            .eraseToAnyPublisher()
        
        return .init(sections: sections,
                     navigation: selectedNavigation,
                     user: showProfile)
    }
    
    private func fetchSections(user: Publishers.Share<AnyPublisher<UserModelResponse, Error>>) -> AnyPublisher<[TableSection], Error> {
        return SocialHighlightService
            .shared
            .fetchSocialHighlight()
            .combineLatest(user)
            .compactMap { [weak self] (highlights, user) in
                guard let self, let data = highlights.data else { return [] }
                let sections = self.buildSection(data, user: user.data)
                return sections
            }
            .eraseToAnyPublisher()
        
    }
    
    private func buildSection(_ socialData: SocialHighlightModel, user: UserModel? = nil) -> [TableSection] {
        var section: [TableSection] = [setupHeadlineSection(socialData: socialData),
                                       setupEventSection(socialData: socialData),
                                       setupNewsSection(socialData: socialData),
                                       setupTweetsSection(socialData: socialData),
                                       setupTrendingTickers(socialData: socialData)].compactMap { $0 }
        
        if let user = user, let tickerStorySection = setupStorySection(user: user) {
            section.insert(tickerStorySection, at: 0)
        }
        
        return section
    }
    
    //MARK: - Sections
    private func setupEventSection(socialData: SocialHighlightModel) -> TableSection? {
        guard let events = socialData.events else  { return nil }
        let footer = [TableRow<ViewMoreFooter>(.init(destination: .viewMoreEvent,
                                                     selectedViewMoreNavigation: self.selectedNavigation))]
        let eventSection = TableSection(rows: [TableRow<CustomCuratedEvents>(.init(events: events, selectedEvent: self.selectedEvent))] + footer, title: "Events")
        return eventSection
    }
    
    private func setupNewsSection(socialData: SocialHighlightModel) -> TableSection? {
        guard let news = socialData.news?.limitTo(to: 5) else { return nil }
        let newsRow = news.compactMap { news in
            let cellModel: NewsCellModel = .init(model: news) {
                self.selectedNavigation.send(.toNews(news))
            }
            return TableRow<NewsCell>(cellModel)
        }
        let footer = [TableRow<ViewMoreFooter>(.init(destination: .viewMoreNews,
                                                     selectedViewMoreNavigation: self.selectedNavigation))]
        return .init(rows: newsRow + footer, title: "News")
    }
    
    private func setupTweetsSection(socialData: SocialHighlightModel) -> TableSection? {
        guard let tweets = socialData.tweets else { return nil }
        
        let collectionCells = tweets.limitTo(to: 5).compactMap { tweet in
            let cellModel: TweetCellModel = .init(model: tweet) {
                self.selectedNavigation.send(.toTweet(tweet))
            }
            return CollectionItem<RecentTweetCard>(cellModel)
        }
        
        let footer = [TableRow<ViewMoreFooter>(.init(destination: .viewMoreTweet,
                                                       selectedViewMoreNavigation: self.selectedNavigation))]
        let tweetSection = TableSection(rows: [TableRow<CollectionTableCell>(.init(cells: collectionCells,
                                                                                   size: Constants.size,
                                                                                   inset: Constants.inset,
                                                                                   cellSize: Constants.cellSize,
                                                                                   interspacing: Constants.interspacing))] + footer,
                                        title: "Top Tweets")
        return tweetSection
    }
    
    private func setupStorySection(user: UserModel) -> TableSection? {
        guard let watchList = user.watching, !watchList.isEmpty else { return nil }
        let collectionCells = watchList.map { ticker in
            let mentionModel = MentionTickerModel(totalMentions: 0, positiveMentions: 0, negativeMentions: 0, neutralMentions: 0, ticker: ticker, name: ticker, sentimentScore: 0)
            let model: MentionCellModel = .init(model: mentionModel, action: nil) { frame in
                self.selectedNavigation.send(.toTickerStory(mentionModel, frame: frame))
            }
            return CollectionItem<TopMentionStoryCell>(model)
        }
        return .init(rows: [TableRow<CollectionTableCell>(.init(cells: collectionCells, inset: .init(vertical: 0, horizontal: 10), cellSize: .init(squared: 64)))])
    }
    
    private func setupTrendingTickers(socialData: SocialHighlightModel) -> TableSection? {
        guard let trending = socialData.topMention?.first?.tickers else { return nil }
        let rows = trending.limitTo(to: 5).compactMap { mention in
            let model = MentionCellModel(model: mention) {
                self.selectedNavigation.send(.toTickerDetail(mention))
            }
            return TableRow<TopMentionCell>(model)
        }
        let footer = [TableRow<ViewMoreFooter>(.init(destination: .viewMoreTrendingTickers(tickers: trending),
                                                       selectedViewMoreNavigation: self.selectedNavigation))]
        return .init(rows: rows + footer, title: "Top Trending Tickers")
    }
    
    private func setupHeadlineSection(socialData: SocialHighlightModel? = nil) -> TableSection? {
        guard let headlines = socialData?.headlines else { return nil }
        return TableSection(rows: [TableRow<TrendingHeadlinesCarousel>(headlines)], title: "Headlines")
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
        
        let buttonBlob = "View More".styled(font: .medium, color: .textColorInverse, size: 12).generateLabel
            .blobify(backgroundColor: .surfaceBackgroundInverse, edgeInset: .init(vertical: 5, horizontal: 10), borderColor: .clear, borderWidth: 0, cornerRadius: 12)
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
        contentView.setFittingConstraints(childView: stack, insets: .init(vertical: 5, horizontal: 10))
        
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

//MARK: - HomeViewModel Constant
extension HomeViewModel {
    enum Constants {
        static let size: CGSize = .init(width: .totalWidth, height: 300)
        static let inset: UIEdgeInsets = .init(vertical: 0, horizontal: 10)
        static let cellSize: CGSize = .init(width: 225, height: 275)
        static let interspacing: CGFloat = 8
    }
}
