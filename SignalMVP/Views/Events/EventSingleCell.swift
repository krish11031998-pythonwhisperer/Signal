//
//  EventSingleCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine

class EventSingleCell: ConfigurableCell {
	
//MARK: - Properties
	private lazy var eventTitle: UILabel = { .init() }()
    private lazy var imgView: UIImageView = { .init(size: .init(squared: 64), cornerRadius: 10) }()
	private lazy var newsArticleCount: UILabel = { .init() }()
    private lazy var tickersView: TickerSymbolView = { .init() }()
    private var cancellable: AnyCancellable?
	
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
        let infoStack: UIStackView = .VStack(subViews: [eventTitle, newsArticleCount, tickersView],spacing: 10, alignment: .leading)
		let mainStack: UIStackView = .HStack(subViews: [imgView, infoStack], spacing: 16, alignment: .top)
		
        let card = mainStack.embedInView(insets: .init(by: 10))
        card.addShadow()
        card.backgroundColor = .surfaceBackground
        card.cornerRadius = 12
        
		contentView.addSubview(card)
		contentView.setFittingConstraints(childView: card, insets: .init(vertical: 10, horizontal: 10))
	}
	
	private func styleCell() {
		selectionStyle = .none
		backgroundColor = .surfaceBackground
	}
	
	
//MARK: - Exposed Methods
	func configure(with model: EventCellModel) {

		model.model.eventName.heading5().render(target: eventTitle)
		eventTitle.numberOfLines = 0

		if let firstImgURL = model.model.news.first?.imageUrl {
			cancellable = UIImage.loadImage(url: firstImgURL, at: imgView, path: \.image)
		}

		"\(model.model.news.count) News Articles".body2Regular(color: .gray).render(target: newsArticleCount)
        tickersView.configTickers(news: model.model)
	}
    
    override func prepareForReuse() {
        cancellable?.cancel()
    }
}
