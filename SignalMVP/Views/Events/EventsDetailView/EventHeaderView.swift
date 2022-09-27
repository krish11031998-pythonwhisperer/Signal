//
//  EventHeaderView.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 26/09/2022.
//

import Foundation
import UIKit

class EventDetailViewHeader: UIView {
	
//MARK: - Properties

	private lazy var eventHeader: UILabel = { .init() }()
	private lazy var newArticleCountLabel: UILabel = { .init() }()
	private lazy var tickerViews: UIStackView = { .HStack(spacing: 8) }()
//MARK: - Constructors
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
//MARK: - Protected Methods
	
	private func setupView() {
		let mainStack: UIStackView = .VStack(subViews: [eventHeader, newArticleCountLabel, tickerViews], spacing: 12, alignment: .fill)
		
		addSubview(mainStack)
		setFittingConstraints(childView: mainStack, insets: .zero)
	}
	
//MARK: - Exposed Methods
	
	public func configureHeader(_ model: EventModel) {
		model.eventName.styled(font: .systemFont(ofSize: 30, weight: .semibold)).render(target: eventHeader)
		"\(model.news.count) News Articles".styled(font: .systemFont(ofSize: 12, weight: .medium)).render(target: newArticleCountLabel)
//		model.tickers.forEach { ticker in
//			let url = "https://cryptoicons.org/api/icon/\(ticker.lowercased())/64"
//			print("(DEBUG) imgUrl : ",url)
//			let imgView = UIImageView(circular: .init(origin: .zero, size: .init(squared: 64)), background: .gray.withAlphaComponent(0.25))
//			imgView.contentMode = .scaleAspectFit
//			UIImage.loadImage(url: url, at: imgView, path: \.image)
//			imgView.setFrame(.init(squared: 64))
//			tickerViews.addArrangedSubview(imgView)
//		}
//		tickerViews.addArrangedSubview(.spacer())

	}
}
