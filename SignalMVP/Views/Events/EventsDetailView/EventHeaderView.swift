//
//  EventHeaderView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 26/09/2022.
//

import Foundation
import UIKit

class EventDetailViewHeader: ConfigurableCell {
	
//MARK: - Properties

	private lazy var eventHeader: UILabel = { .init() }()
	private lazy var newArticleCountLabel: UILabel = { .init() }()
    private lazy var tickerViews: TickerSymbolView = { .init() }()
//MARK: - Constructors
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
//MARK: - Protected Methods
	
	private func setupView() {
		let mainStack: UIStackView = .VStack(subViews: [eventHeader, newArticleCountLabel, tickerViews], spacing: 12, alignment: .leading)
		eventHeader.numberOfLines = 0
		addSubview(mainStack)
		setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
		selectionStyle = .none
		backgroundColor = .clear
		isUserInteractionEnabled = false
	}
	
//MARK: - Exposed Methods
	
	public func configure(with model: EventModel) {
		model.eventName.heading1().render(target: eventHeader)
		"\(model.news.count) News Articles".body3Regular().render(target: newArticleCountLabel)

        tickerViews.isHidden = model.tickers.isEmpty
        tickerViews.configTickers(news: model)
	}
}
