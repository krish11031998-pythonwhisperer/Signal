//
//  SentimentCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/11/2022.
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
            return .init(color: .appIndigo, nameText: sentiment, val: Float(neutralMentions)/Float(total))
        default:
            return nil
        }
    }
}

class SentimentCell: ConfigurableCell {
    
    private lazy var progressBar: MultipleStrokeProgressBarAlt = { .init(frame: .zero) }()
    private lazy var legend: UIStackView = { .HStack(spacing: 8) }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stack = [progressBar, legend].embedInVStack(alignment: .leading, spacing: 7.5)
        stack.setFittingConstraints(childView: progressBar, leading: 0, trailing: 0)
        contentView.addSubview(stack)
        progressBar.setHeight(height: 10, priority: .needed)
        contentView.setFittingConstraints(childView: stack, insets: .init(by: 10))
        backgroundColor = .surfaceBackground
    }
    
    func configure(with model: EmptyModel) {
        guard let mention = MentionStorage.selectedMention else { return }
        
        let accountRatios:[MultipleStrokeModel] = [
            mention.chartModel(for: "Positive"),
            mention.chartModel(for: "Negative"),
            mention.chartModel(for: "Neutral")].compactMap { $0 }
        
    
        Sentiment.allCases.compactMap {
            switch $0 {
                case .positve:
                    return $0.sentimentIndicator(mention.positiveMentions)
                case .negative:
                    return $0.sentimentIndicator(mention.negativeMentions)
                case .neutral:
                    return $0.sentimentIndicator(mention.neutralMentions)
            }
        }.addToView(legend, removeChildren: true)
        
        progressBar.configureProgressBar(ratios: accountRatios)
    }
}
