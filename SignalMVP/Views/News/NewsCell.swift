//
//  NewsCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

class NewsCell: ConfigurableCell {

//MARK: - Properties
	private lazy var newsImage: UIImageView = { .init() }()
	private lazy var timestamp: UILabel = { .init() }()
	private lazy var title: UILabel = { .init() }()
	private lazy var body: UILabel = { .init() }()
	private lazy var tickersStack: UIStackView = { UIView.HStack(spacing: 8) }()
	
//MARK: - Constructors
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCell()
		styleCell()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupCell()
		styleCell()
	}
	
//MARK: - Protected Methods
	
	private func styleCell() {
		selectedBackgroundView = UIView()
		selectedBackgroundView?.backgroundColor = .clear
		selectionStyle = .none
		backgroundColor = .clear
	}
	
	private func setupCell() {
		let mainStack = UIView.VStack(spacing: 10)
		let newsInfo = UIView.VStack(subViews: [timestamp, title, body, tickersStack], spacing: 8)
		newsInfo.setCustomSpacing(12, after: body)
		newsInfo.backgroundColor = .purple.withAlphaComponent(0.1)
		let cellStack = UIView.HStack(subViews: [newsInfo, newsImage], spacing: 16, alignment: .top)
		tickersStack.isHidden = true
		
		mainStack.addArrangedSubview(cellStack)
		
		let divider = UIView.divider()
		mainStack.addArrangedSubview(divider.embedInView(insets: .init(top: 10, left: 0, bottom: 0, right: 0)))
		
		newsImage.setFrame(.init(squared: 84))
		newsImage.cornerRadius = 10
		newsImage.clipsToBounds = true
		
		contentView.addSubview(mainStack)
		contentView.setFittingConstraints(childView: mainStack, insets: .init(vertical: 10, horizontal: 16))
	}
	
//MARK: - Exposed Methods
	
	public func configure(with model: NewsCellModel) {
		model.model.date.styled(font: .systemFont(ofSize: 10, weight: .regular), color: .gray).render(target: timestamp)
		model.model.title.styled(font: .systemFont(ofSize: 20, weight: .semibold), color: .white).render(target: title)
		title.numberOfLines = 0
		model.model.sourceName.styled(font: .systemFont(ofSize: 14, weight: .regular), color: .gray).render(target: body)
		body.numberOfLines = 1
		
		if !model.model.tickers.isEmpty {
			tickersStack.removeChildViews()
			
			model.model.tickers.limitTo(to: 3).forEach { ticker in
				let tickerLabel = UILabel()
				ticker.styled(font: .systemFont(ofSize: 12, weight: .medium), color: .white).render(target: tickerLabel)
				tickersStack.addArrangedSubview(tickerLabel.blobify(backgroundColor: .white.withAlphaComponent(0.15),
																	borderColor: .white,
																	borderWidth: 1,
																	cornerRadius: 10))
			}
			tickersStack.addArrangedSubview(.spacer())
			tickersStack.addArrangedSubview(model.model.sentimentBlob)
			tickersStack.isHidden = false
		}
		
		UIImage.loadImage(url: model.model.imageUrl, at: newsImage, path: \.image)
		newsImage.contentMode = .scaleAspectFill
	}
	
}
