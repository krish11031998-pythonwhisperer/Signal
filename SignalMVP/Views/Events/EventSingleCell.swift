//
//  EventSingleCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

class EventSingleCell: ConfigurableCell {
	
//MARK: - Properties
	private lazy var eventTitle: UILabel = { .init() }()
    private lazy var imgView: UIImageView = { .init(size: .init(squared: 64), cornerRadius: 10) }()
	private lazy var newsArticleCount: UILabel = { .init() }()
	private lazy var tickersView: UIStackView = { UIView.HStack(spacing: 8) }()
	
//MARK: - Overriden
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
		styleCell()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
		styleCell()
	}
	
//MARK: - Protected Methods
	
	private func setupViews() {
		let infoStack: UIStackView = .VStack(subViews: [eventTitle, newsArticleCount],spacing: 10)
		let stack: UIStackView = .HStack(subViews: [imgView, infoStack], spacing: 16, alignment: .center)
		let mainStack: UIStackView = .VStack(subViews: [stack], spacing: 12)
		mainStack.setHeight(height: 84, priority: .required)
		
		contentView.addSubview(mainStack)
		contentView.setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
		contentView.addShadowBackground(inset: .init(vertical: 7.5, horizontal: 8), cornerRadius: 12)
	}
	
	private func styleCell() {
		selectionStyle = .none
		backgroundColor = .surfaceBackground
	}
	
	
//MARK: - Exposed Methods
	func configure(with model: EventCellModel) {

		model.model.eventName.body1Bold().render(target: eventTitle)
		eventTitle.numberOfLines = 2

		if let firstImgURL = model.model.news.first?.imageUrl {
			UIImage.loadImage(url: firstImgURL, at: imgView, path: \.image)
		}

		"\(model.model.news.count) News Articles".body2Regular(color: .gray).render(target: newsArticleCount)
		
//		tickersView.isHidden = model.model.tickers.isEmpty
//		if !model.model.tickers.isEmpty {
//			model.model.tickers.limitTo(to: 3).forEach {
//				let label = UILabel()
//				$0.styled(font: .systemFont(ofSize: 13, weight: .regular), color: .white).render(target: label)
//
//				tickersView.addArrangedSubview(label.blobify(backgroundColor: .white.withAlphaComponent(0.3),
//															 borderColor: .white,
//															 borderWidth: 1,
//															 cornerRadius: 10))
//			}
//			tickersView.addArrangedSubview(.spacer())
//		}
	}
}
