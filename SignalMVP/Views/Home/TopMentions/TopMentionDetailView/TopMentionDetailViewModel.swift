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

fileprivate extension MentionModel {
    
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

fileprivate extension UIView {
    func segmentBlob(isSelected: Bool) -> UIView {
        let bg: UIColor = isSelected ? .surfaceBackgroundInverse : .clear
        let inset: UIEdgeInsets = .init(by: 10)
        let container = blobify(backgroundColor: bg, edgeInset: inset, borderColor: .textColor, borderWidth: 1, cornerRadius: 0)
        container.cornerRadius = container.compressedSize.height.half
        return container
    }
}

//MARK: - SegmentSections
enum Sections: String, CaseIterable {
    case twitter, news, events
}

class TopMentionDetailViewModel {
    
    private var tweets:[TweetModel] = []
    private var news: [NewsModel] = []
    private var events: [EventModel] = []
    private let mention: MentionModel
    private var selectedTab: CurrentValueSubject<Sections, Never> = .init(.news)
    private var bag: Set<AnyCancellable> = .init()
    init(mention: MentionModel) {
        self.mention = mention
    }
    
    var ticker: String {
        mention.ticker
    }

    struct Output {
        let sections: AnyPublisher<[TableCellProvider], Error>
    }
    
    func transform() -> Output {
        let section = selectedTab
            .flatMap({ [weak self] in
                guard let `self` = self else {
                    return Fail<[TableCellProvider], Error>(error: ObjectError.objectOutOfMemory).eraseToAnyPublisher()
                }
                return self.dataForSection($0)
            })
            .eraseToAnyPublisher()
        
        return .init(sections: section)
    }
    
    private func dataForSection(_ section: Sections) -> AnyPublisher<[TableCellProvider], Error> {
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
        TweetService
            .shared
            .fetchTweets(entity: ticker, refresh: false)
            .catch { err in
                print("(ERROR) err [From Service]:", err)
                return StubTweetService.shared.fetchTweets()
            }
            .compactMap { result in
                result.data?.compactMap { TableRow<TweetCell>(.init(model: $0)) }
            }
            .map {[weak self] in
                guard let self else { return [] }
                return self.mediaHeaderView + $0
            }
            .eraseToAnyPublisher()
    }

    
    private func fetchNews(after: String? = nil) -> AnyPublisher<[TableCellProvider], Error> {
        NewsService
            .shared
            .fetchNews(entity: [ticker])
            .catch { err in
                print("(ERROR) err [From Service]:", err)
                return StubNewsService.shared.fetchNews()
            }
            .compactMap { result in
                result.data?.compactMap { TableRow<NewsCell>(.init(model: $0)) }
            }
            .map {[weak self] in
                guard let self else { return [] }
                return self.mediaHeaderView + $0
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchEvents(after: String? = nil) -> AnyPublisher<[TableCellProvider], Error> {
        EventService
            .shared
            .fetchEvents(entity: [ticker], refresh: false)
            .compactMap { result in
                result.data.compactMap { TableRow<EventSingleCell>(.init(model: $0)) }
            }
            .map {[weak self] in
                guard let self else { return [] }
                return self.mediaHeaderView + $0
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
    let selectedTab: CurrentValueSubject<Sections, Never>
}

class MediaSegmentCell: ConfigurableCell {
    
    private var selectedTab:  CurrentValueSubject<Sections, Never>? = nil
    private var bag: Set<AnyCancellable> = .init()
    private lazy var stack: UIStackView = {
        Sections.allCases.compactMap { tabSection in
            let tab = tabSection.rawValue
            let blob = tab.capitalized.body2Medium(color: .textColor).generateLabel.segmentBlob(isSelected: false)
            
            return blob.buttonify { [weak self] in
                self?.selectedTab?.send(tabSection)
            }
        }.embedInHStack(alignment: .center, spacing: 5)
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
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
                guard let self,
                      let selectedTabIdx = Sections.allCases.firstIndex(of: section),
                      selectedTabIdx < self.stack.arrangedSubviews.count && selectedTabIdx >= 0 else { return }
                self.stack.arrangedSubviews.forEach { $0.subviews.first?.backgroundColor = .clear }
                self.stack.arrangedSubviews[selectedTabIdx].subviews.first?.backgroundColor = .red
            }
            .store(in: &bag)
    }
    
    func configure(with model: MediaSegmentModel) {
        self.selectedTab = model.selectedTab
        setupSelectedTab()
    }
}
