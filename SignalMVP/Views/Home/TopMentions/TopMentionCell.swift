//
//  TopMentionCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit

fileprivate extension UIView {
	
	func generateMentionsBlob(_ sentiment: String, _ val: Int) -> UIView {
		let color: UIColor = sentiment == "Positive" ? .green : sentiment == "Negative" ? .red : .white
		let label =  "\(sentiment) : \(val)".styled(font: .systemFont(ofSize: 12, weight: .medium), color: color).generateLabel
		return label.blobify(backgroundColor: color.withAlphaComponent(0.2), borderColor: color)
	}
	
}

fileprivate extension MentionModel {
	
	func count(_ sentiment: Sentiment) -> Int {
		switch sentiment {
		case .positve:
			return positiveMentions
		case .negative:
			return negativeMentions
		case .neutral:
			return neutralMentions
		}
	}
	
}

class TopMentionCell: ConfigurableCell {
	private static var visited: [String: Bool] = [:]
	private lazy var symbolView: SymbolImage = {
		let view = SymbolImage()
		return view
	}()
	private lazy var detailStack: UIStackView = { .HStack(spacing: 12, alignment: .center) }()
	private lazy var mainStack: UIStackView = { .VStack(spacing: 8) }()
	private lazy var mentionDistribution: UIStackView = { .HStack(spacing: 8) }()
	private lazy var circularChart: CircularProgressbar = { .init(frame: .init(origin: .zero, size: .init(squared: 48))) }()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}

	private func setupView() {
		
		[symbolView, .spacer(),circularChart].forEach(detailStack.addArrangedSubview(_:))
		circularChart.setFrame(.init(squared: 48))
		mainStack.addArrangedSubview(detailStack)
		mainStack.addArrangedSubview("Sentiments".styled(font: .systemFont(ofSize: 10, weight: .regular), color: .gray).generateLabel)
		mainStack.setCustomSpacing(16, after: detailStack)
		mainStack.addArrangedSubview(mentionDistribution)
		mentionDistribution.isHidden = true
		contentView.addSubview(mainStack)
		contentView.setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
	}
	
	func configure(with model: MentionModel) {
		selectionStyle = .none
		backgroundColor = .clear
		
		symbolView.configureView(symbol: model.ticker, imgSize: .init(squared: 32), label: model.ticker.styled(font: .systemFont(ofSize: 18, weight: .medium)))
		
		let percent: CGFloat = CGFloat(model.positiveMentions)/CGFloat(model.totalMentions - model.neutralMentions)
		let color: UIColor = percent < 0.5 ? .red : .green
		let visited = isCellVisited(ticker: model.ticker)
		circularChart.configureChart(label: (String(format: "%.0f", percent * 10) + " / 10").styled(font: .systemFont(ofSize: 12, weight: .regular)),
									 color: color,
									 percent,
									 visited: visited)
		if !visited {
			circularChart.animateValue(color: color, percent)
		}
	
		mentionDistribution.removeChildViews()
		Sentiment.allCases.forEach { mentionDistribution.addArrangedSubview($0.sentimentIndicator(" : \(model.count($0))")) }
		
		mentionDistribution.addArrangedSubview(.spacer())
		mentionDistribution.isHidden = false
	}
}


//MARK: - Visited Extension

extension TopMentionCell {
	
	func isCellVisited(ticker: String) -> Bool {
		guard let isVisited = Self.visited[ticker] else {
			Self.visited[ticker] = true
			return false
		}
		return isVisited
	}
	
}
