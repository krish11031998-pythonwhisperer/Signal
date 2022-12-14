//
//  EventCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

class EventCell: ConfigurableCell {

//MARK: - Properties
	private lazy var mainNews: EventView = { .init(largeCard: true) }()
	private lazy var otherNews: UIStackView = { .init() }()
	
//MARK: - Constructors
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
		styleCell()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
		styleCell()
	}
	
	private func setupView() {
		let stack = UIView.VStack(subViews: [mainNews, otherNews], spacing: 12, alignment: .leading)
		stack.setCustomSpacing(4, after: otherNews)
		contentView.addSubview(stack)
		contentView.setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 8))
		mainNews.isHidden = true
		otherNews.isHidden = true
	}
	
	private func styleCell() {
		backgroundColor = .clear
		selectionStyle = .none
	}
	
	func configure(with model: EventModel) {
		if let firstNews = model.news.first {
			mainNews.configureView(model: firstNews)
			mainNews.isHidden = false
		}
		
		if model.news.count >= 3 {
			let otherViews: [UIView] = Array(model.news[1..<3]).compactMap {
				let view = EventView()
				view.configureView(model: $0)
				return view
			}
			otherNews.arrangedSubviews.forEach { $0.removeFromSuperview() }
			otherViews.forEach(otherNews.addArrangedSubview(_:))
			otherNews.spacing = 8
			otherNews.distribution = .fillEqually
			otherNews.isHidden = false
		}
	}
}


class EventView: UIView  {
	
	private var news: NewsModel?
	private lazy var imageView: UIImageView = { .init() }()
	private lazy var authorTitle: UILabel = { .init() }()
	private lazy var newsTitle: UILabel = { .init() }()
    private var tickersView: TickerSymbolView = { .init() }()
    
	private let largeCard: Bool
	
	init(largeCard: Bool = false) {
		self.largeCard = largeCard
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		self.largeCard = false
		super.init(coder: coder)
		setupView()
	}
	
	var height: CGFloat { largeCard ? (CGFloat.totalWidth - 32) * 0.7 : 140 }
	
	private func setupView() {

        let bottomStack: UIStackView = .HStack(subViews: [authorTitle, .spacer(), tickersView], spacing: 8, alignment: .center)
        let infoStack = UIView.VStack(subViews: [.spacer(), newsTitle, bottomStack],spacing: 8)
        let bgView = UIView()
        bgView.backgroundColor = .black.withAlphaComponent(0.3)
        
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		authorTitle.numberOfLines = 1
        newsTitle.numberOfLines = largeCard ? 3 : 2
		
        [imageView, bgView, infoStack].addToView(self)
        
        imageView.fillSuperview()
        bgView.fillSuperview()
        infoStack.fillSuperview(inset: .init(by: 10))
        
        setHeight(height: largeCard ? 250 : 200, priority: .needed)
		clipsToBounds = true
		cornerRadius = 16
	}
	
	public func configureView(model: NewsModel, addTapGesture: Bool = true) {
		
		news = model
		
		UIImage.loadImage(url: model.imageUrl, at: imageView, path: \.image)
		
		model.sourceName.body2Medium(color: .gray).render(target: authorTitle)
		model.title.body1Bold().render(target: newsTitle)
		
		tickersView.isHidden = model.tickers.isEmpty
		if let validNews = news, !model.tickers.isEmpty {
            tickersView.configTickers(news: validNews)
        }
		
		if addTapGesture {
			self.addTapGesture()
		}
	}
	
	private func addTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addTapHandler))
//		tapGesture.cancelsTouchesInView = true
		addGestureRecognizer(tapGesture)
	}
	
	@objc
	private func addTapHandler() {
		NewsStorage.selectedNews = news
	}
}

