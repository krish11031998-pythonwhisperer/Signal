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
	private lazy var imgView: UIImageView = {
		let imgView = UIImageView()
		imgView.contentMode = .scaleAspectFill
		imgView.cornerRadius = 10
		imgView.clipsToBounds = true
		imgView.setFrame(.init(squared: 64))
		return imgView
	}()
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
		let infoStack: UIStackView = .VStack(subViews: [eventTitle, newsArticleCount, tickersView],spacing: 10)
		let stack: UIStackView = .HStack(subViews: [imgView, infoStack], spacing: 16, alignment: .top)
		let divider: UIView =  .divider(color: .white.withAlphaComponent(0.5)).embedInView(insets: .zero)
		let mainStack: UIStackView = .VStack(subViews: [stack, divider],
											 spacing: 12)
		contentView.addSubview(mainStack)
		contentView.setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
	}
	
	private func styleCell() {
		selectionStyle = .none
		backgroundColor = .clear
	}
	
	
//MARK: - Exposed Methods
	func configure(with model: EventCellModel) {
		
		tickersView.removeChildViews()

		model.model.eventName.styled(font: .systemFont(ofSize: 15, weight: .semibold), color: .white).render(target: eventTitle)
		eventTitle.numberOfLines = 2

		if let firstImgURL = model.model.news.first?.imageUrl {
			UIImage.loadImage(url: firstImgURL, at: imgView, path: \.image)
		}

		"\(model.model.news.count) News Articles".styled(font: .systemFont(ofSize: 13, weight: .regular), color: .gray).render(target: newsArticleCount)

		tickersView.isHidden = model.model.tickers.isEmpty
		if !model.model.tickers.isEmpty {
			model.model.tickers.limitTo(to: 3).forEach {
				let label = UILabel()
				$0.styled(font: .systemFont(ofSize: 13, weight: .regular), color: .white).render(target: label)

				tickersView.addArrangedSubview(label.blobify(backgroundColor: .white.withAlphaComponent(0.3),
															 borderColor: .white,
															 borderWidth: 1,
															 cornerRadius: 10))
			}
			tickersView.addArrangedSubview(.spacer())
		}
	}
}
