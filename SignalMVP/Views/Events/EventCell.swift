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
	
	private lazy var title: UILabel = { .init() }()
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
		let stack = UIView.VStack(subViews: [title], spacing: 12, alignment: .leading)
		let newsStack = UIView.VStack(subViews: [mainNews, otherNews], spacing: 8).embedInView(insets: .init(vertical: 8, horizontal: 8))
//		newsStack.backgroundColor = .gray.withAlphaComponent(0.1)
//		newsStack.addBlurView()
//		newsStack.clipsToBounds = true
//		newsStack.cornerRadius = 10
		stack.addArrangedSubview(newsStack)
		let divider = UIView()
		divider.backgroundColor = .gray
		stack.addArrangedSubview(divider.embedInView(insets: .init(top: 10, left: 0, bottom: 0, right: 0)))
		divider.setHeight(height: 0.5, priority: .required)
	
		addSubview(stack)
		setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 8))
		
		mainNews.isHidden = true
		otherNews.isHidden = true
	}
	
	private func styleCell() {
		backgroundColor = .clear
		selectionStyle = .none
	}
	
	func configure(with model: EventModel) {

		model.eventName.styled(font: .systemFont(ofSize: 17.5, weight: .bold),color: .white).render(target: title)
		title.numberOfLines = 2

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
	
	private lazy var imageView: UIImageView = { .init() }()
	private lazy var authorTitle: UILabel = { .init() }()
	private lazy var newsTitle: UILabel = { .init() }()
	private lazy var tickersView: UIStackView = { UIView.HStack(spacing: 8) }()
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
		let stack = UIView.VStack(subViews: [imageView], spacing: 4)
		let infoStack = UIView.VStack(subViews: [newsTitle, authorTitle, tickersView],spacing: 5)
		infoStack.setCustomSpacing(8, after: authorTitle)
		stack.addArrangedSubview(infoStack.embedInView(insets: .init(vertical: 8, horizontal: 4)))
		stack.alignment = .leading
	
		stack.setCustomSpacing(10, after: newsTitle)
		
		imageView.setHeight(height: largeCard ? 240 : 140, priority: .required)
		imageView.cornerRadius = 10
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		tickersView.isHidden = true
		authorTitle.numberOfLines = 1
		newsTitle.numberOfLines = 2
		
		addSubview(stack)
		setFittingConstraints(childView: stack, insets: .init(top: 0, left: 0, bottom: 8, right: 0))
	}
	
	public func configureView(model: NewsModel) {
		UIImage.loadImage(url: model.imageUrl, at: imageView, path: \.image)
		
		model.sourceName.styled(font: .systemFont(ofSize: 10, weight: .semibold), color: .gray).render(target: authorTitle)
		model.title.styled(font: .systemFont(ofSize: 15, weight: .regular), color: .white).render(target: newsTitle)
		
		tickersView.isHidden = model.tickers.isEmpty
		if !model.tickers.isEmpty {
			tickersView.removeChildViews()
			model.tickers.limitTo(to: 3).forEach {
				let label = UILabel()
				$0.styled(font: .systemFont(ofSize: 13, weight: .regular), color: .white).render(target: label)
				
				tickersView.addArrangedSubview(label.blobify(backgroundColor: .white.withAlphaComponent(0.3),
															 borderColor: .white,
															 borderWidth: 1,
															 cornerRadius: 8))
			}
			tickersView.addArrangedSubview(.spacer())
		}
	}
}

