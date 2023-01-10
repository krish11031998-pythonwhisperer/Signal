//
//  TopMentionDetailViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 05/11/2022.
//

import Foundation
import UIKit
import Combine

enum ObjectError: String, Error {
    case objectOutOfMemory
}

extension ChartCandleModel {
    init(_ data: SentimentModel) {
        self.init(positive: data.positive ?? 1, neutral: data.neutral ?? 1, negative: data.negative ?? 1)
    }
}


//MARK: - SegmentSections
enum TickerMediaSections: String, CaseIterable {
    case twitter, news, events
}


class TickerDetailViewModel {
    
    private var tweets:[TweetModel] = []
    private var news: [NewsModel] = []
    private var events: [EventModel] = []
    private let mention: MentionTickerModel
    var tableUpdateAnimation: (UITableView.RowAnimation, UITableView.RowAnimation) = (.fade, .fade)
    var selectedTab: CurrentValueSubject<TickerMediaSections, Never> = .init(.news) {
        willSet {
            let idx = TickerMediaSections.allCases.firstIndex(of: selectedTab.value) ?? 0
            let newIdx = TickerMediaSections.allCases.firstIndex(of: newValue.value) ?? 0
            if idx > newIdx {
                tableUpdateAnimation = (.left, .left)
            } else if idx < newIdx {
                tableUpdateAnimation = (.right, .right)
            } else {
                tableUpdateAnimation = (.fade, .fade)
            }
        }
    }
    let loading: PassthroughSubject<Bool, Never> = .init()
    private var navigateTo: PassthroughSubject<Navigation, Never> = .init()
    private var bag: Set<AnyCancellable> = .init()
    init(mention: MentionTickerModel) {
        self.mention = mention
    }
    
    var ticker: String {
        mention.ticker
    }

    enum Navigation {
        case tweet(model: TweetModel)
        case news(model: NewsModel)
        case event(model: EventModel)
    }
    
    struct Output {
        let section: AnyPublisher<[TableSection], Error>
        let mediaSection: AnyPublisher<[TableCellProvider], Error>
        let navigation: AnyPublisher<Navigation, Never>
    }
    
    func transform() -> Output {
        
        let sentiment = fetchSentiment().share().eraseToAnyPublisher()
        
        let newsSection: AnyPublisher<TableSection, Error> = dataForSection(.news)
            .receive(on: RunLoop.main)
            .compactMap {
                return TableSection(rows: $0, title: "Media", customHeader: MediaSegmentControl(selectedTab: self.selectedTab))
            }
            .eraseToAnyPublisher()
        
        let sentimentSection: AnyPublisher<[TableSection], Error> = sentiment.eraseToAnyPublisher()
            .compactMap { sentiment in
                guard let candles = sentiment.timeline?.values else { return nil }
                let candleModel = candles.map { ChartCandleModel($0)}
            
                let monthlySentiment = TableSection(rows: [TableRow<SentimentRatingCell>(candleModel)], title: "Month Sentiment")
                let totalSentiment = TableSection(rows: [TableRow<SentimentTotalCell>(sentiment)])
                return [totalSentiment, monthlySentiment]
            }.eraseToAnyPublisher()
        
        let section = Publishers.Zip(sentimentSection, newsSection)
            .compactMap { $0 + [$1] }.eraseToAnyPublisher()
        
        let mediaSection = selectedTab
            .dropFirst(1)
            .handleEvents(receiveOutput: { [weak self] _ in self?.loading.send(true) })
            .flatMap({ [weak self] in
                guard let `self` = self else {
                    return Fail<[TableCellProvider], Error>(error: ObjectError.objectOutOfMemory).eraseToAnyPublisher()
                }
                return self.dataForSection($0)
            })
            .eraseToAnyPublisher()
        
        //sentiment.connect()
        return .init(section: section,
                     mediaSection: mediaSection,
                     navigation: navigateTo.eraseToAnyPublisher())
    }
    
    private func dataForSection(_ section: TickerMediaSections) -> AnyPublisher<[TableCellProvider], Error> {
        switch section {
        case .twitter:
            return self.fetchTweets()
        case .events:
            return self.fetchEvents()
        case .news:
            return self.fetchNews()
        }
    }
    
    private func fetchTweets(after: String? = nil) -> AnyPublisher<[TableCellProvider], Error> {
        TickerService
            .shared
            .fetchTweets(ticker: ticker, refresh: false)
            .compactMap { [weak self] result in
                result.data?.tweets?.compactMap {tweet in
                    let model: TweetCellModel = .init(model: tweet) {
                        self?.navigateTo.send(.tweet(model: tweet))
                    }
                    return TableRow<TweetCell>(model)
                }
            }
            .eraseToAnyPublisher()
    }

    
    private func fetchNews(after: String? = nil) -> AnyPublisher<[TableCellProvider], Error> {
        TickerService
            .shared
            .fetchNews(ticker: ticker, refresh: true)
            .catch { err in
                print("(ERROR) err [From Service]:", err)
                return StubNewsService.shared.fetchNewsForAllTickers()
            }
            .compactMap { [weak self]  result in
                result.data?.compactMap { news in
                    let model: NewsCellModel = .init(model: news) {
                        self?.navigateTo.send(.news(model: news))
                    }
                    return TableRow<NewsCell>(model)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchEvents(after: String? = nil) -> AnyPublisher<[TableCellProvider], Error> {
        TickerService
            .shared
            .fetchEvent(ticker: ticker, refresh: true)
            .compactMap {[weak self] result in
                result.data.compactMap { event in
                    let model: EventCellModel = .init(model: event) {
                        self?.navigateTo.send(.event(model: event))
                    }
                    return TableRow<EventSmallCell>(model)
                }
            }
            .eraseToAnyPublisher()
    }
 
    private func fetchSentiment() -> AnyPublisher<SentimentForTicker, Error> {
        TickerService
            .shared
            .fetchSentiment(ticker: ticker, refresh: false)
            .compactMap(\.data)
            .eraseToAnyPublisher()
    }
    
    var mediaHeaderView: [TableCellProvider] {
        return [TableRow<MediaSegmentCell>(.init(selectedTab: selectedTab))]
    }
    
}


//MARK: - TopMentionMediaSegmentCell

struct MediaSegmentModel {
    let selectedTab: CurrentValueSubject<TickerMediaSections, Never>
}

class MediaSegmentCell: ConfigurableCell {
    
    weak private var selectedTab:  CurrentValueSubject<TickerMediaSections, Never>?
    private var bag: Set<AnyCancellable> = .init()
    private lazy var stack: UIStackView = {
        TickerMediaSections.allCases.compactMap { tabSection in
            return SegmentTabCell(value: tabSection, subject: selectedTab ?? .init(.news))
        }.embedInHStack(alignment: .center, spacing: 5)
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        stack.addArrangedSubview(.spacer())
        contentView.addSubview(stack)
        contentView.setFittingConstraints(childView: stack, insets: .init(by: 10))
        backgroundColor = .surfaceBackground
        selectionStyle = .none
    }
    
    private func setupSelectedTab() {
        selectedTab?
            .sink{ [weak self] section in
                self?.stack.arrangedSubviews.forEach {
                    ($0 as? SegmentTabCell<TickerMediaSections>)?.updateBlob()
                }
            }
            .store(in: &bag)
    }
    
    func configure(with model: MediaSegmentModel) {
        self.selectedTab = model.selectedTab
        setupView()
        setupSelectedTab()
    }
}

