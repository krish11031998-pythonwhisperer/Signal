//
//  NewsCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine
class NewsCell: ConfigurableCell {

//MARK: - Properties
    private lazy var newsImage: UIImageView = { .init(size: .init(squared: 84), cornerRadius: 10) }()
    private var imgCancellable: Cancellable?
	private lazy var timestamp: UILabel = { .init() }()
	private lazy var title: UILabel = { .init() }()
	private lazy var body: UILabel = { .init() }()
	private lazy var sentimentView: UILabel = { .init() }()
    private lazy var tickersView: TickerSymbolView = { .init() }()
    private lazy var tickersStack: UIStackView = { .HStack(subViews: [tickersView, .spacer(), sentimentView], spacing: 8) }()
    
	private lazy var newsInfoStack: UIStackView = {
        let stack: UIStackView = .VStack(subViews: [timestamp, title, .spacer(), body, tickersStack],spacing: 8)
		stack.setCustomSpacing(12, after: body)
		return stack
	}()
	
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
		backgroundColor = .surfaceBackground
	}
	
	private func setupCell() {
		let mainStack = UIView.VStack(spacing: 10)
		let cellStack = UIView.HStack(subViews: [newsInfoStack, newsImage], spacing: 16, alignment: .top)
		tickersView.isHidden = true
		
		mainStack.addArrangedSubview(cellStack)
        
        let card = mainStack.blobify(backgroundColor: .surfaceBackground,
                                     edgeInset: .init(by: 12),
                                     borderColor: .clear,
                                     borderWidth: 0,
                                     cornerRadius: 12)
        card.addShadow()
		contentView.addSubview(card)
		contentView.setFittingConstraints(childView: card, insets: .init(by: 10))
	}
	
//MARK: - Exposed Methods
	
    override func prepareForReuse() {
        imgCancellable?.cancel()
    }
    
	public func configure(with model: NewsCellModel) {
        model.model.date.timestamp.bodySmallRegular(color: .gray).render(target: timestamp)
		model.model.title.heading5().render(target: title)
		title.numberOfLines = 0
		model.model.sourceName.body2Regular(color: .gray).render(target: body)
		body.numberOfLines = 1
		
        if let tickers = model.model.tickers, !tickers.isEmpty {
			tickersView.isHidden = false
            tickersView.configTickers(news: model.model)
        } else {
            tickersStack.insertAndReplaceArrangedSubview("General News".body3Regular(color: .textColor).generateLabel, at: 0)
        }
        model.model.sentiment.sentimentIndicatorText().render(target: sentimentView)
		
        imgCancellable = UIImage.loadImage(url: model.model.imageUrl, at: newsImage, path: \.image)
		newsImage.contentMode = .scaleAspectFill
	}
	
}
