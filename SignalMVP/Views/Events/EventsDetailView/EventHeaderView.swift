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
	
	private lazy var mainNews: EventView = { .init(largeCard: true) }()
	private lazy var otherNews: UIStackView = { .init() }()
	
//MARK: - Constructors
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	
//MARK: - Protected Methods
	
	private func setupView() {
		let stack: UIStackView = .VStack(spacing: 12)
		[mainNews, otherNews].forEach(stack.addArrangedSubview(_:))
		
		addSubview(stack)
		setFittingConstraints(childView: stack, insets: .init(vertical: 10, horizontal: 16))
	}
	
//MARK: - Exposed Methods
	
	public func configureHeader(_ model: EventModel) {
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
