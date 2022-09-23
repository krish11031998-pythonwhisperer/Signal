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
		let stack = UIView.VStack(subViews: [title, mainNews, otherNews], spacing: 12)
		addSubview(stack)
		setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 16))
		
		mainNews.isHidden = true
		otherNews.isHidden = true
	}
	
	private func styleCell() {
		backgroundColor = .clear
		selectionStyle = .none
	}
	
	func configure(with model: EventModel) {

		model.eventName.styled(font: .systemFont(ofSize: 20, weight: .semibold),color: .blue).render(target: title)
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
		let stack = UIView.VStack(subViews: [imageView, authorTitle, newsTitle], spacing: 8)
		stack.alignment = .leading
	
		imageView.setHeight(height: largeCard ? 240 : 140, priority: .required)
		imageView.cornerRadius = 10
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		
		authorTitle.numberOfLines = 1
		newsTitle.numberOfLines = 2
		
		addSubview(stack)
		setFittingConstraints(childView: stack, insets: .zero)
	}
	
	public func configureView(model: NewsModel) {
		UIImage.loadImage(url: model.imageUrl, at: imageView, path: \.image)
		
		model.sourceName.styled(font: .systemFont(ofSize: 10, weight: .medium), color: .gray).render(target: authorTitle)
		model.title.styled(font: .systemFont(ofSize: 13, weight: .regular), color: .white).render(target: newsTitle)
	}
}

