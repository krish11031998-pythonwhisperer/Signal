//
//  TopMentionDetailViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 05/11/2022.
//

import Foundation
import UIKit


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

class TopMentionDetailViewModel {
    
    public var tableView: AnyTableView?
    private(set) var tweets:[TweetModel] = []
    var group: DispatchGroup
    
    init() {
        group = .init()
    }
    
    var ticker: String {
        MentionStorage.selectedMention?.ticker ?? ""
    }
    
    
    public func fetchData() {
        fetchTweets()
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView?.reloadTableWithDataSource(strongSelf.buildDataSource())
        }
    }
    
    private func fetchTweets() {
        group.enter()
        StubTweetService.shared.fetchTweets(entity: ticker) { [weak self] in
            guard let tweets = $0.data?.data else {
                self?.group.leave()
                return
            }
            self?.tweets = tweets
            self?.group.leave()
        }
    }
    
    private var tweetSection: TableSection? {
        guard !tweets.isEmpty else { return nil }
        return .init(rows: tweets.map { TableRow<TweetCell>(.init(model: $0)) }, title: "Media")
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
        
        return .init(rows: [TableRow<CustomTableCell>(.init(view: mainStack, inset: .init(vertical: 10, horizontal: 10)))], title: "Sentiment")
        
    }
    
    private func buildDataSource() -> TableViewDataSource {
        .init(sections: [sentimentSplitView, tweetSection].compactMap { $0 })
    }
}