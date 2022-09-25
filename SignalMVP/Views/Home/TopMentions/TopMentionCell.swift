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

class TopMentionCell: ConfigurableCell {
	private static var visited: [String: Bool] = [:]
	private lazy var coinImage: UIImageView = {
		let imageView: UIImageView = .init(circular: .init(origin: .zero, size: .init(squared: 32)), background: .gray)
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	private lazy var detailStack: UIStackView = { .HStack(spacing: 12, alignment: .center) }()
	private lazy var coinName: UILabel = { .init() }()
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
		
		[coinImage, coinName, .spacer(),circularChart].forEach(detailStack.addArrangedSubview(_:))
		circularChart.setFrame(.init(squared: 48))
		coinImage.setFrame(.init(squared: 32))
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
		
		model.ticker.styled(font: .systemFont(ofSize: 18, weight: .medium)).render(target: coinName)
		
		let percent: CGFloat = CGFloat(model.positiveMentions)/CGFloat(model.totalMentions - model.neutralMentions)
		let color: UIColor = percent < 0.5 ? .red : .green
		let visited = isCellVisited(ticker: model.ticker)
		circularChart.configureChart(color: color, percent, visited: visited)
		if !visited {
			circularChart.animateValue(color: color, percent)
		}
	
		mentionDistribution.removeChildViews()
		[generateMentionsBlob("Positive", model.positiveMentions), generateMentionsBlob("Negative", model.negativeMentions), generateMentionsBlob("Neutral", model.neutralMentions)]
			.forEach(mentionDistribution.addArrangedSubview(_:))
		
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
