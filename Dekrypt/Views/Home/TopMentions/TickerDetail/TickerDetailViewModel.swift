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

fileprivate extension MentionTickerModel {
    
    var total: Int { positiveMentions + neutralMentions + negativeMentions }
    
    func chartModel(for sentiment: String) -> MultipleStrokeModel? {
        switch sentiment {
        case "Positive":
            return .init(color: .appGreen, nameText: sentiment, val: Float(positiveMentions)/Float(total))
        case "Negative":
            return .init(color: .appRed, nameText: sentiment, val: Float(negativeMentions)/Float(total))
        case "Neutral":
            return .init(color: .appOrange, nameText: sentiment, val: Float(neutralMentions)/Float(total))
        default:
            return nil
        }
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
        let sections: AnyPublisher<[TableCellProvider], Error>
        let sentiment: AnyPublisher<[ChartCandleModel], Error>
        let navigation: AnyPublisher<Navigation, Never>
    }
    
    func transform() -> Output {
        let section = selectedTab
            .handleEvents(receiveOutput: { [weak self] _ in self?.loading.send(true) })
            .flatMap({ [weak self] in
                guard let `self` = self else {
                    return Fail<[TableCellProvider], Error>(error: ObjectError.objectOutOfMemory).eraseToAnyPublisher()
                }
                return self.dataForSection($0)
            })
            .eraseToAnyPublisher()
        
        return .init(sections: section, sentiment: fetchSentiment(), navigation: navigateTo.eraseToAnyPublisher())
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
 
    private func fetchSentiment() -> AnyPublisher<[ChartCandleModel], Error> {
        TickerService
            .shared
            .fetchSentiment(ticker: ticker, refresh: false)
            .compactMap(\.data)
            .map {
                guard let time = $0.timeline?.values else { return [] }
                return time.compactMap { sentiment in
                    guard let positive = sentiment.positive,
                          let negative = sentiment.negative,
                          let neutral = sentiment.neutral
                    else { return nil }
                    return ChartCandleModel(positive: positive, neutral: neutral, negative: negative)
                }
            }
            .eraseToAnyPublisher()
    }
    
    var mediaHeaderView: [TableCellProvider] {
        return [TableRow<MediaSegmentCell>(.init(selectedTab: selectedTab))]
    }
    
    var sentimentSplitView: TableSection? {
        let accountRatios:[MultipleStrokeModel] = [
            mention.chartModel(for: "Positive"),
            mention.chartModel(for: "Negative"),
            mention.chartModel(for: "Neutral")].compactMap { $0 }
        
        let chart = MultipleStrokeProgressBarAlt(frame: .init(origin: .zero, size: .init(width: .totalWidth - 20, height: 16)))
        chart.configureProgressBar(ratios: accountRatios)
        
        let legend: UIStackView = .HStack(subViews: accountRatios.compactMap {
            let indicator: UIView = .init(circular: .init(origin: .zero, size: .init(squared: 8)), background: $0.color)
            indicator.setFrame(.init(squared: 8))
            let stack: UIStackView = .HStack(subViews: [indicator, $0.name.generateLabel], spacing: 5, alignment: .center)
            return stack
        }, spacing: 10)
        legend.addArrangedSubview(.spacer())
        let mainStack: UIStackView = .VStack(subViews: [legend, chart] , spacing: 10)
        
        return .init(rows: [TableRow<SentimentCell>(mention)], title: "Sentiment")
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

