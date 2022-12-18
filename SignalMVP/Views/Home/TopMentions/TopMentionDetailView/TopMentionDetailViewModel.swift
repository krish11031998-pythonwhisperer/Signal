//
//  TopMentionDetailViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 05/11/2022.
//

import Foundation
import UIKit
import Combine

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

class TopMentionDetailViewModel {
    
    public var tableView: AnyTableView?
    private var tweets:[TweetModel] = []
    private var news: [NewsModel] = []
    private var events: [EventModel] = []
    private var selectedTab: String = "Twitter"
    var group: DispatchGroup
    private var bag: Set<AnyCancellable> = .init()
    init() {
        group = .init()
    }
    
    var ticker: String {
        MentionStorage.selectedMention?.ticker ?? ""
    }
    
    public func fetchData() {
        fetchTweets()
        tableView?.reloadTableWithDataSource(buildDataSource())
    }
    
    private func fetchTweets(completion: Callback? = nil) {
        StubTweetService.shared.fetchTweets(entity: nil, before: nil, after: nil, limit: 20)
            .compactMap { $0.data }
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: {[weak self] tweets in
                self?.tweets = tweets
                completion?()
            }
            .store(in: &bag)

    }
    
    private func fetchNews(completion: Callback?) {
        StubNewsService.shared.fetchNews(tickers: ticker)
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .failure(let err):
                    print("(DEBUG) err : ", err)
                default: break
                }
            } receiveValue: { [weak self] result in
                self?.news = result.data ?? []
                completion?()
            }
            .store(in: &bag)

    }
    
    private func fetchEvents(completion: Callback?) {
        StubEventService.shared.fetchEvents()
            .compactMap { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] events in
                self?.events = events
                completion?()
            })
            .store(in: &bag)
    }
    
    private func header(_ tab: String) {
        
        switch tab {
        case "Twitter":
            selectedTab = "Twitter"
            guard let mediaSecion = mediaSecion else { return }
            tableView?.reloadSection(mediaSecion, at: 1)
        case "News":
            selectedTab = "News"
            fetchNews { [weak self] in
                guard let mediaSecion = self?.mediaSecion else { return }
                self?.tableView?.reloadSection(mediaSecion, at: 1)
            }
        case "Events":
            selectedTab = "Events"
            fetchEvents { [weak self] in
                guard let mediaSecion = self?.mediaSecion else { return }
                self?.tableView?.reloadSection(mediaSecion, at: 1)
            }
        default:
            break
        }
    }
    
    private var mediaHeaderView: UIView {
        let customHeader = "Media".heading2().generateLabel
        let customSelector = ["Twitter", "News", "Events"].compactMap { tab in
            let textColor: UIColor = selectedTab == tab ? .textColorInverse : .textColor
            let blob = tab.body2Medium(color: textColor).generateLabel.segmentBlob(isSelected: selectedTab == tab)
            return blob.buttonify { self.header(tab) }
        }.embedInHStack(alignment: .center, spacing: 5)
        customSelector.addArrangedSubview(.spacer())
        let stack = UIStackView.VStack(subViews: [customHeader, customSelector], spacing: 10)
        return stack.embedInView(insets: .init(by: 10), priority: .needed)
    }
    
    private var mediaSecion: TableSection? {
        var rows: [TableCellProvider] = []

        switch selectedTab {
        case "Twitter":
            rows = tweets.limitTo(to: 2).map { TableRow<TweetCell>(.init(model: $0)) }
        case "News":
            rows = news.limitTo(to: 2).map { TableRow<NewsCell>(.init(model: $0)) }
        case "Events":
            rows = events.limitTo(to: 2).map { TableRow<EventSingleCell>(.init(model: $0)) }
        default:
            break
        }
        
        return .init(rows: rows, customHeader: mediaHeaderView)
        
    }
    
    private var sentimentSplitView: TableSection? {
        guard let mention = MentionStorage.selectedMention else { return nil }
        
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
        
        return .init(rows: [TableRow<SentimentCell>(.init())], title: "Sentiment")
        
    }
    
    private func buildDataSource() -> TableViewDataSource {
        .init(sections: [sentimentSplitView, mediaSecion].compactMap { $0 })
    }
}
